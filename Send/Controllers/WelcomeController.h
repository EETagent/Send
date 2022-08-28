//
//  ViewController.h
//  Send
//

#import <Cocoa/Cocoa.h>

#import "DropDelegate.h"

#import "DropView.h"

@interface WelcomeController : NSViewController <DropDelegate>

@property (nonatomic, weak) IBOutlet DropView *dropView;

// Respond to openDocument in menu
- (void)openDocument:(id)sender;

@end

