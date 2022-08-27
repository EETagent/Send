//
//  File.h
//  Send
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property NSString *filename;

@property NSURL *path;

@property NSUInteger size;

- (instancetype) initWithFilename:(NSString*)filename withPath:(NSURL*)path withSize:(NSUInteger)size;

@end
