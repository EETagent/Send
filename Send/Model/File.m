//
//  File.m
//  Send
//

#import "File.h"

@implementation File

- (instancetype)initWithPath:(NSString *)filePath {
    self = [super init];
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];

        NSString *fileName= [fileManager displayNameAtPath:filePath];
        NSError *error;
        
        NSUInteger fileSize = 0;
        
        BOOL isDir = NO;
        [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
        
        if (!isDir)
            fileSize = [[fileManager attributesOfItemAtPath:filePath error:&error] fileSize];
        // Get file size of directory
        else {
            NSArray *filesArray = [fileManager subpathsOfDirectoryAtPath:filePath error:nil];
            NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
            NSString *fileName;
            while (fileName = [filesEnumerator nextObject]) {
                NSDictionary *fileDictionary = [fileManager attributesOfItemAtPath:[filePath stringByAppendingPathComponent:fileName]  error:nil];
                fileSize += [fileDictionary fileSize];
            }
        }
        
        [self setName:fileName];
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
    if ([[self name] isEqualTo:[casted name]] && [[self path] isEqualTo:[casted path]] && [self size] == [casted size])
        return YES;
    return NO;
}

@end
