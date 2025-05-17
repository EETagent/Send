//
//  ViewController.h
//  Send
//

#import <Cocoa/Cocoa.h>

#import "DropDelegate.h"

#import "DropView.h"

@interface WelcomeController : NSViewController <DropDelegate>

@property (nonatomic, weak) IBOutlet DropView *dropView;
@property (nonatomic, weak) IBOutlet NSTextFieldCell *maxSizeLabel;

// Respond to openDocument in menu
- (void)openDocument:(id)sender;

- (void)openPath:(NSString *)path;

@end

