//
//  File.h
//  Send
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property NSString *filename;

@property NSURL *path;

@property NSUInteger size;

- (instancetype)initWithPath:(NSURL *)path;

+ (NSString *) getStringRepresentationFromSize:(NSUInteger)size;

- (NSString *) getSizeAsString;


@end
