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
    // Load data
    [[self fileListView] reloadData];
    // Autoresize to full width
    [[self fileListView] sizeLastColumnToFit];
    // Set total size
    [self reloadTotalSize];
}

- (void)dealloc {
    [[self fileListView] unregisterDraggedTypes];
}

- (void)moveToWelcomeView {
    NSViewController *controller = [[self storyboard] instantiateControllerWithIdentifier:@"WelcomeView"];
    [[[self view] window] setContentViewController:controller];
}

- (void)reloadTotalSize {
    NSUInteger size = 0;
    for (File *file in [self fileList]) {
        size += [file size];
    }
    NSString *totalSize = [File getStringRepresentationFromSize:size];
    // TODO: Translate string
    NSString *string = [NSString stringWithFormat:@"Celková velikost: %@", totalSize];
    [[self totalSize] setStringValue:string];
}

- (void)addFilesToTable:(NSArray<NSURL *> *)files {
    for (NSURL *path in files) {
        File *file = [[File alloc] initWithPath:path];
        // Prevent duplicates
        BOOL isNotInArray = YES;
        for (File *item in [self fileList]) {
            if ([item isEqualTo:file]) {
                isNotInArray = NO;
                break;
            }
        }
        if (isNotInArray)
            [[self fileList] addObject:file];
    }
    [[self fileListView] reloadData];
    [self reloadTotalSize];
}


- (void)openFile:(id)sender {
    NSOpenPanel* openDialog = [NSOpenPanel openPanel];
    [openDialog setCanChooseFiles:YES];
    [openDialog setAllowsMultipleSelection:YES];
    [openDialog setCanChooseDirectories:NO];
    
    if ( [openDialog runModal] == NSModalResponseOK ) {
        NSArray* urls = [openDialog URLs];
        [self addFilesToTable: urls];
    }
}

- (void)dropFilesAdded:(NSArray<NSURL *> *)files {
    [self addFilesToTable:files];
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
                [[fileItemView size] setStringValue:[file getSizeAsString]];
            }
            return fileItemView;
        }
    }
    return nil;
}

- (void)fileItemDeletedWithIndex:(NSUInteger)index {
    [[self fileList] removeObjectAtIndex:index];
    [[self fileListView] reloadData];
    [self reloadTotalSize];
    if ([[self fileList] count] == 0)
        [self moveToWelcomeView];
}

@end
