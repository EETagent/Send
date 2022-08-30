//
//  SettingsStackView.m
//  Send
//

#import "SettingsStackView.h"

@implementation SettingsStackView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        if ([[self passwordCheckBox] state] == NSControlStateValueOn)
            [[self passwordTextField] setEnabled:YES];
    }
    return self;
}

- (void)passwordCheckBoxClicked:(id)sender {
    if ([[self passwordCheckBox] state] == NSControlStateValueOn) {
        [[self passwordTextField] setEnabled:YES];
        return;
    }
    [[self passwordTextField] setEnabled:NO];
}

- (long long)parseExpiry {
    NSPopUpButton *button = [self expiryPopUpButton];
    const long long minute = 60;
    switch ([button indexOfSelectedItem]) {
        case 0:
            // 5 minutes
            return 5*minute;
        case 1:
            // 1 hour
            return 60*minute;
        case 2:
            // 1 days
            return 24*60*minute;
        case 3:
            // 7 days
            return 7*24*60*minute;
        default:
            return 60*minute;
    }
}

- (unsigned char)parseLimit {
    NSPopUpButton *button = [self limitPopUpButton];
    switch ([button indexOfSelectedItem]) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
            return [button indexOfSelectedItem] + 1;
        case 6:
            // 20 downloads
            return 20;
        default:
            return 3;
    }
}

- (NSString *)parsePassword {
    if ([[self passwordCheckBox] state] == NSControlStateValueOn)
        return [[self passwordTextField] stringValue];
    return nil;
}

@end
