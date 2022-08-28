//
//  DropTableView.m
//  Send
//
//  Created by Vojtěch Jungmann on 28.08.2022.
//

#import "DropTableView.h"

@implementation DropTableView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        // Drag & Drop for file types
        [self registerForDraggedTypes:[NSArray arrayWithObjects: (NSString*)kUTTypeFileURL, nil]];
        // Forward dataSource to self for Drag & Drop
        [self setDataSource:self];
    }
    return self;
}

- (void)dealloc {
    [self unregisterDraggedTypes];
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    return NSDragOperationCopy;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    NSPasteboard *pasteboard = [info draggingPasteboard];
    if ([[pasteboard types] containsObject:NSURLPboardType]) {
        NSArray *urls = [pasteboard readObjectsForClasses:@[[NSURL class]] options:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self dropDelegate] dropFilesAdded:[urls copy]];
        });
        return YES;
    }
    return NO;
}

// Forward dataSource function to second delegate in FilesViewController
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[self sourceDelegate] numberOfRowsInTableView:tableView];
}

@end
