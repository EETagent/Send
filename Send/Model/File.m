//
//  File.m
//  Send
//

#import "File.h"

@implementation File

- (instancetype)initWithPath:(NSURL *)path {
    self = [super init];
    if (self) {
        NSURL *filePath = [path filePathURL];
        NSString *filePathString = [filePath path];
        //NSString *fileNameWithoutExtension = [[[NSFileManager defaultManager] displayNameAtPath:filePathString] stringByDeletingPathExtension];
        NSString *fileName= [[NSFileManager defaultManager] displayNameAtPath:filePathString];
        NSError *error;
        NSUInteger fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePathString error:&error] fileSize];
        [self setFilename:fileName];
        [self setPath:filePath];
        [self setSize:fileSize];
    }
    return self;
}

- (NSString *)getSizeAsString {
    return [File getStringRepresentationFromSize:[self size]];
}

+ (NSString *)getStringRepresentationFromSize:(NSUInteger)size {
    double convertedValue = size;
    
    NSArray *tokens = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB"];
    
    NSInteger multiplyFactor = 0;
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, tokens[multiplyFactor]];
}

@end
