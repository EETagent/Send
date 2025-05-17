//
//  SettingsViewController.h
//  Send
//

#import <Cocoa/Cocoa.h>

@interface SettingsViewController : NSViewController

@property (weak) IBOutlet NSTextField *sendInstanceURLTextField;
@property (weak) IBOutlet NSTextField *maxDownloadsTextField;
@property (weak) IBOutlet NSStepper *maxDownloadsStepper;
@property (weak) IBOutlet NSTextField *maxDurationTextField;
@property (weak) IBOutlet NSStepper *maxDurationStepper;
@property (weak) IBOutlet NSTextField *maxFileSizeTextField;
@property (weak) IBOutlet NSStepper *maxFileSizeStepper;

// - (IBAction)stepperValueChanged:(NSStepper *)sender;
- (IBAction)textFieldValueChanged:(NSTextField *)sender;

@end
