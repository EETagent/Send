//
//  DropView.h
//  Send
//

#import <Cocoa/Cocoa.h>

#import "DropDelegate.h"

@interface DropView : NSView

@property (nonatomic, weak) IBOutlet id <DropDelegate> dropDelegate;

- (IBAction)openFile:(id)sender;

@end
