//
//  ShareViewController.h
//  Send Share
//

#import <Cocoa/Cocoa.h>

#import <Send_Library/SendUploadDelegate.h>

#import "SettingsStackView.h"
#import "ResultView.h"

@interface ShareViewController : NSViewController <SendUploadDelegate>

@property(nonatomic, weak) IBOutlet NSButton *mainButton;

@property(nonatomic, weak) IBOutlet NSProgressIndicator *progressIndicator;

@property(nonatomic, weak) IBOutlet SettingsStackView *settingsStackView;

@property(nonatomic, weak) IBOutlet ResultView *resultView;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

@end
