//
//  SettingsStackView.h
//  Send
//

#import <Cocoa/Cocoa.h>

@interface SettingsStackView : NSStackView

@property(nonatomic, weak) IBOutlet NSPopUpButton *limitPopUpButton;
@property(nonatomic, weak) IBOutlet NSPopUpButton *expiryPopUpButton;

@property(nonatomic, weak) IBOutlet NSButton *passwordCheckBox;
@property(nonatomic, weak) IBOutlet NSSecureTextField *passwordTextField;

- (IBAction)passwordCheckBoxClicked:(id)sender;

- (long long)parseExpiry;
- (unsigned char)parseLimit;
- (NSString *)parsePassword;

@end
