//
//  SendDownloadDelegate.h
//  Send
//
//  Created by Vojtěch Jungmann on 26.08.2022.
//

#import <Foundation/Foundation.h>

@protocol SendUploadDelegate <NSObject>

@optional

- (void)fileUploadStartedWithSize:(NSUInteger)size;

- (void)fileUploadProgressWithTotalBytesUploaded:(NSUInteger)bytes;

- (void)fileUploadCompleted;

@end
