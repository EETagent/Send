//
//  FilesViewController.h
//  Send
//

#import <Cocoa/Cocoa.h>

#import "FileItemViewDelegate.h"
#import "DropDelegate.h"

#import "File.h"

@interface FilesViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, FileItemViewDelegate, DropDelegate>

@property (nonatomic, weak) IBOutlet NSTableView *fileListView;

@property (nonatomic, weak) IBOutlet NSTextField *totalSize;


- (IBAction)openFile:(id)sender;

@property NSMutableArray<File*> *fileList;

@end
