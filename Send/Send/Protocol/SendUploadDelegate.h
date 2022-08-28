//
//  SendDownloadDelegate.h
//  Send
//

#import <Foundation/Foundation.h>

@protocol SendUploadDelegate <NSObject>

@optional

- (void)fileUploadStartedWithSize:(NSUInteger)size;

- (void)fileUploadProgressWithTotalBytesUploaded:(NSUInteger)bytes;

- (void)fileUploadCompleted;

@end
