//
//  SettingsStackView.m
//  Send
//

#import "SettingsStackView.h"
#import "SettingsManager.h"

@implementation SettingsStackView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        if ([[self passwordCheckBox] state] == NSControlStateValueOn)
            [[self passwordTextField] setEnabled:YES];        
        [self updateLimitOptions];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib]; 

    [self updateLimitOptions];
    [self updateExpiryOptions];
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
            // 3 days
            return 3*24*60*minute;
        case 4:
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
            // ++index downloads
            return [button indexOfSelectedItem] + 1;
        case 5:
            // 10 downloads
            return 10;
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

- (NSInteger)durationMinutesForIndex:(NSInteger)index {
    switch (index) {
        case 0: return 5;           // 5 minut
        case 1: return 60;          // 1 hodina
        case 2: return 24 * 60;     // 1 den
        case 3: return 3 * 24 * 60; // 3 dny
        case 4: return 7 * 24 * 60; // 7 dní
        default: return 60; 
    }
}

- (void)updateExpiryOptions {
    NSPopUpButton *button = [self expiryPopUpButton];
    NSInteger maxDuration = [[SettingsManager sharedManager] maxDurationMinutes];


    for (NSInteger i = 0; i < [button numberOfItems]; ++i) {
        NSMenuItem *item = [button itemAtIndex:i];
        NSInteger itemDuration = [self durationMinutesForIndex:i];

        [item setEnabled:(itemDuration <= maxDuration)];
    }
}

- (void)updateLimitOptions {
    NSPopUpButton *button = [self limitPopUpButton];
    NSInteger maxLimit = [[SettingsManager sharedManager] maxDownloadLimit];

    for (NSMenuItem *item in [button itemArray]) {
        NSInteger itemValue = [[[item title] componentsSeparatedByString:@" "] firstObject].integerValue;
        
       if (itemValue > 0) { 
             [item setEnabled:(itemValue <= maxLimit)];
    }
    }
}

@end
