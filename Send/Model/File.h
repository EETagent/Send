//
//  File.h
//  Send
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property NSString *filename;

@property NSString *path;

@property NSUInteger size;

- (NSURL*)urlPath;

- (instancetype)initWithPath:(NSString *)path;

- (instancetype)initWithURLPath:(NSURL *)path;

- (NSString *) stringSize;

+ (NSString *) StringRepresentationFromSize:(NSUInteger)size;

@end
