//
//  FileItemView.h
//  Send
//

#import <Cocoa/Cocoa.h>

#import "FileItemViewDelegate.h"

@interface FileItemView : NSStackView

@property (nonatomic, weak) id <FileItemViewDelegate> fileDelegate;

@property NSUInteger index;

@property (nonatomic, weak) IBOutlet NSTextField *name;

@property (nonatomic, weak) IBOutlet NSTextField *size;

-(IBAction) deleteItem:(id) sender;

@end
