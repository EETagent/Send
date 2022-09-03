//
//  File.h
//  Send
//

#import <Foundation/Foundation.h>

@interface File : NSObject

- (instancetype)initWithPath:(NSString *)path;

- (instancetype)initWithURLPath:(NSURL *)path;

@property NSString *name;

@property NSString *path;

@property NSUInteger size;

@property BOOL isFolder;

- (NSURL*)urlPath;

- (NSString *) stringSize;

+ (NSString *) StringRepresentationFromSize:(NSUInteger)size;

@end
