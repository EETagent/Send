//
//  FilesViewController.m
//  Send
//

#import "FilesViewController.h"

#import "FileItemView.h"

#import "File.h"

@implementation FilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFileList:[NSMutableArray new]];
    
    for (NSString *name in @[@"aa", @"bb", @"cc", @"dd"]) {
        File *file = [[File alloc] initWithFilename:name withPath:[NSURL new] withSize:10];
        [[self fileList] addObject:file];
    }

    [[self fileListView] reloadData];
    // Autoresize to full width
    [[self fileListView] sizeLastColumnToFit];

}

- (void)moveToWelcomeView {
    NSViewController *controller = [[self storyboard] instantiateControllerWithIdentifier:@"WelcomeView"];
    [[[self view] window] setContentViewController:controller];
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
    return NO;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[self fileList] count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualTo:@"fileColumn"]) {
        FileItemView *fileItemView =  [tableView makeViewWithIdentifier:@"fileItem" owner:self];
        if (fileItemView) {
            File *file = [[self fileList] objectAtIndex:row];
            [fileItemView setIndex:row];
            [fileItemView setFileDelegate:self];
            if (file) {
                [[fileItemView name] setStringValue:[file filename]];
            }
            return fileItemView;
        }
    }
    return nil;
}

- (void)fileItemDeletedWithIndex:(NSUInteger)index {
    [[self fileList] removeObjectAtIndex:index];
    [[self fileListView] reloadData];
    if ([[self fileList] count] == 0)
        [self moveToWelcomeView];
}

@end
