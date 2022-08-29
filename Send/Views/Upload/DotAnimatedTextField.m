//
//  DotAnimatedTextField.m
//  Send
//

#import "DotAnimatedTextField.h"

#define ANIMATION_SPEED 0.4f

@implementation DotAnimatedTextField {
    NSTimer *statusAnimationTimer;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self->statusAnimationTimer  = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_SPEED repeats:YES block:^(NSTimer *timer) {
                [self dotAnimation];
        }];
    }
    return self;
}

- (void)dealloc {
    [self->statusAnimationTimer invalidate];
}

- (void)dotAnimation {
    if (![self isAnimating])
        return;
    
    // Persistent state store
    static short state = 0;
    
    NSString *textFieldValue = [self stringValue];
    
    // Write arbitary count of dots to string block
    void (^defineDots)(short) = ^void(short count) {
        NSMutableString *temp = [textFieldValue mutableCopy];
        while ([temp hasSuffix:@"."])
            [temp deleteCharactersInRange:NSMakeRange([temp length]-1, 1)];
        for (short i = 0; i < count; i++)
            [temp appendString:@"."];
        [self setStringValue:temp];
    };
    
    switch (state) {
        case 0:
        case 1:
            // Increment state before passing to defineDots function
            defineDots(++state);
            break;
        case 2:
            defineDots(3);
            state = 0;
            break;
    }
}

- (void)startAnimating {
    [self setIsAnimating:YES];
}

- (void)stopAnimating {
    [self setIsAnimating:NO];
}

@end
