//
//  DotAnimatedTextField.h
//  Send
//

#import <Cocoa/Cocoa.h>

@interface DotAnimatedTextField : NSTextField

@property BOOL isAnimating;

- (void)startAnimating;
- (void)stopAnimating;

@end
