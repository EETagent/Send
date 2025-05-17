//
//  SettingsViewController.m
//  Send
//

#import "SettingsViewController.h"
#import "../Shared/SettingsManager.h"

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SettingsManager *settings = [SettingsManager sharedManager];
    
    self.sendInstanceURLTextField.stringValue = [[settings sendURL] absoluteString] ?: @""; // Use SendURL
    self.maxDownloadsTextField.integerValue = settings.maxDownloadLimit;
    self.maxDurationTextField.integerValue = settings.maxDurationMinutes;
    self.maxFileSizeTextField.integerValue = settings.maxFileSizeInMB;
}


// - (IBAction)stepperValueChanged:(NSStepper *)sender {
//     if (sender == self.maxDownloadsStepper) {
//         self.maxDownloadsTextField.integerValue = sender.integerValue;
//     } else if (sender == self.maxDurationStepper) {
//         self.maxDurationTextField.integerValue = sender.integerValue;
//     } else if (sender == self.maxFileSizeStepper) {
//         self.maxFileSizeTextField.integerValue = sender.integerValue;
//     }
// }

- (IBAction)textFieldValueChanged:(NSTextField *)sender {
    SettingsManager *settings = [SettingsManager sharedManager];

    if (sender == self.sendInstanceURLTextField) {
        NSString *urlString = sender.stringValue;
        NSURL *url = [NSURL URLWithString:urlString];
        if (url && ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"])) {
            self.sendInstanceURLTextField.stringValue = urlString;
            [settings setSendURL:url];
        } 
    }
    else if (sender == self.maxDownloadsTextField) {
        [settings setMaxDownloadLimit:sender.integerValue];
    } else if (sender == self.maxDurationTextField) {
       [settings setMaxDurationMinutes:sender.integerValue];
    } else if (sender == self.maxFileSizeTextField) {
        [settings setMaxFileSizeInMB:sender.integerValue];
    }
}



@end
