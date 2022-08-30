//
//  FilesViewController.m
//  Send
//

#import "FilesViewController.h"
#import "UploadViewController.h"

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
    NSString *totalSize = [File StringRepresentationFromSize:size];
    NSString *string = [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"Total size:", @"Total size in FilesView"), totalSize];
    [[self totalSize] setStringValue:string];
}

- (void)addFilesToTable:(NSArray<NSURL *> *)files {
    for (NSURL *path in files) {
        File *file = [[File alloc] initWithURLPath:path];
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

- (void)openDocument:(id)sender {
    [self openFile:sender];
}

- (void)openPath:(NSString *)path {
    NSArray<NSURL *> *array = [NSArray arrayWithObject:[NSURL fileURLWithPath:path]];
    [self addFilesToTable:array];
}

- (void)dropFilesAdded:(NSArray<NSURL *> *)files {
    [self addFilesToTable:files];
}

- (long long)parseExpiry {
    NSPopUpButton *button = [self expiryPopUpButton];
    const long long minute = 60;
    switch ([button indexOfSelectedItem]) {
        case 0:
            // 5 minutes
            return 5*minute;
        case 1:
            // 1 hour
            return 60*minute;
        case 2:
            // 1 days
            return 24*60*minute;
        case 3:
            // 7 days
            return 7*24*60*minute;
        default:
            return 60*minute;
    }
}

- (unsigned char)parseLimit {
    NSPopUpButton *button = [self limitPopUpButton];
    switch ([button indexOfSelectedItem]) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
            return [button indexOfSelectedItem] + 1;
        case 6:
            // 20 downloads
            return 20;
        default:
            return 3;
    }
}

- (void)uploadFilesToSend:(id)sender {
    if ([[self fileList] count] < 1)
        return;
    UploadViewController *controller = [[self storyboard] instantiateControllerWithIdentifier:@"UploadView"];
    [controller uploadFiles:[self fileList] withExpiry:[self parseExpiry] withLimit:[self parseLimit]];
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
            if (file)
                [fileItemView setupWithFile:file];
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
