//
//  DropView.h
//  Send
//

#import <Cocoa/Cocoa.h>

#import "DropViewDelegate.h"

@interface DropView : NSView

@property (nonatomic, weak) IBOutlet id <DropViewDelegate> dropViewDelegate;

- (IBAction)openFile:(id)sender;

@end
