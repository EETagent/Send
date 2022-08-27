//
//  FilesViewController.h
//  Send
//

#import <Cocoa/Cocoa.h>

#import "FileItemViewDelegate.h"

#import "File.h"

@interface FilesViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, FileItemViewDelegate>

@property (nonatomic, weak) IBOutlet NSTableView *fileListView;

@property NSMutableArray<File*> *fileList;

@end
