//
//  SendUploadDelegate.h
//  libffsendObjc
//

#import <Foundation/Foundation.h>

@protocol SendUploadDelegate <NSObject>

- (void)sendUploadStartedWithSize:(NSUInteger)size;

- (void)sendUploadProgressWithTotalBytesUploaded:(NSUInteger)bytes;

- (void)sendUploadCompleted;

- (void)sendUploadFailedWithError:(NSError *)error;

@end

