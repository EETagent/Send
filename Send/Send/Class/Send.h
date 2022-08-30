//
//  Send.h
//  Send
//

#import <Foundation/Foundation.h>

#import "SendUploadDelegate.h"

@interface Send : NSObject

@property (nonatomic, weak) id <SendUploadDelegate> delegate;

@property NSString *password;
@property long long expiry;
@property unsigned char limit;

- (void)uploadFileWithURLPath:(NSURL*)path;
- (void)uploadFileWithPath:(NSString*)path;

- (void)uploadFilesWithPaths:(NSArray<NSString *> *)files tempFileCreatedAtBlock:(void (^)(NSString *path))tempFileBlock;

- (NSString *)uploadedFileGetId;
- (long long)uploadedFileGetExpireAt;
- (NSString *)uploadedFileGetURL;
- (NSString *)uploadedFileGetSecret;

- (NSURL *)uploadedFileGetLink;

@end
