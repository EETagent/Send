//
//  File.m
//  Send
//

#import "File.h"

@implementation File

- (instancetype)initWithPath:(NSString *)filePath {
    self = [super init];
    if (self) {
        //NSString *fileNameWithoutExtension = [[[NSFileManager defaultManager] displayNameAtPath:filePathString] stringByDeletingPathExtension];
        NSString *fileName= [[NSFileManager defaultManager] displayNameAtPath:filePath];
        NSError *error;
        NSUInteger fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error] fileSize];
        [self setFilename:fileName];
        [self setPath:filePath];
        [self setSize:fileSize];
    }
    return self;
}

- (instancetype)initWithURLPath:(NSURL *)fileURLPath {
    NSString *filePath = [fileURLPath path];
    self = [self initWithPath:filePath];
    return self;
}

- (NSURL *)urlPath {
    return [NSURL fileURLWithPath:[self path]];
}

- (NSString *)stringSize {
    return [File StringRepresentationFromSize:[self size]];
}

+ (NSString *)StringRepresentationFromSize:(NSUInteger)size {
    double convertedValue = size;
    
    NSArray *tokens = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB"];
    
    NSInteger multiplyFactor = 0;
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, tokens[multiplyFactor]];
}

- (BOOL)isEqualTo:(id)object {
    if (![object isKindOfClass:[File class]])
        return NO;
    File *casted = (File*)object;
    if ([[self filename] isEqualTo:[casted filename]] && [[self path] isEqualTo:[casted path]] && [self size] == [casted size])
        return YES;
    return NO;
}

@end
