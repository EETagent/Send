//
//  SendDownloadDelegate.h
//  Send
//

#import <Foundation/Foundation.h>

@protocol SendUploadDelegate <NSObject>

@optional

- (void)sendUploadStartedWithSize:(NSUInteger)size;

- (void)sendUploadProgressWithTotalBytesUploaded:(NSUInteger)bytes;

- (void)sendUploadCompleted;

@end
