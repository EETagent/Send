//
//  File.m
//  Send
//

#import "File.h"

@implementation File

- (instancetype)initWithFilename:(NSString *)filename withPath:(NSURL *)path withSize:(NSUInteger)size {
    self = [super init];
    if (self) {
        [self setFilename:filename];
        [self setPath:path];
        [self setSize:size];
    }
    return self;
}

@end
