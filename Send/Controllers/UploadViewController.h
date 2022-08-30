//
//  UploadViewController.h
//  Send
//

#import <Cocoa/Cocoa.h>

#import "SendUploadDelegate.h"

#import "FileItemView.h"

#import "ResultView.h"

#import "DotAnimatedTextField.h"

#import "File.h"

@interface UploadViewController : NSViewController <SendUploadDelegate>

@property(nonatomic, weak) IBOutlet DotAnimatedTextField *statusTextField;
@property(nonatomic, weak) IBOutlet NSProgressIndicator *progressIndicator;

@property(nonatomic, weak) IBOutlet FileItemView *fileItemView;

@property(nonatomic, weak) IBOutlet ResultView *resultView;

- (IBAction)returnToWelcome:(id)sender;

- (void)uploadFiles:(NSArray<File *> *)files withExpiry:(long long)expiry withLimit:(unsigned char)limit withPassword:(NSString *)password;

@end

