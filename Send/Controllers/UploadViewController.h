//
//  UploadViewController.h
//  Send
//

#import <Cocoa/Cocoa.h>

#import "SendUploadDelegate.h"

#import "FileItemView.h"

#import "File.h"

@interface UploadViewController : NSViewController <SendUploadDelegate>

@property (nonatomic, weak) IBOutlet NSTextField *statusTextField;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, weak) IBOutlet FileItemView *fileItemView;

- (void)uploadFiles:(NSArray<File *> *)files;

@end

