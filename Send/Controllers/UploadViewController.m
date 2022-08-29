//
//  UploadViewController.m
//  Send
//

#import "UploadViewController.h"

#import "Send.h"

#import "File.h"

@implementation UploadViewController {
    Send *send;
    File *file;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)uploadFiles:(NSArray<File *> *)files {
    if ([files count] == 0)
        return;
    
    self->send = [Send new];
    [self->send setDelegate:self];
    
    // Single file
    if ([files count] == 1) {
        self->file = [files objectAtIndex:0];
        NSString *path = [self->file path];
        // Start download
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self->send uploadFileWithPath:path];
        });
        return;
    }
    
    // Multiple files
    NSMutableArray<NSString *> *filePaths = [NSMutableArray new];
    // Map would be fancy
    for (File *file in files)
        [filePaths addObject:[file path]];
    // Start download
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->send uploadFilesWithPaths:filePaths tempFileBlock:^(NSString *path) {
            // Update file with created ZIP location
            File *file = [[File alloc] initWithPath:path];
            self->file = file;
        }];
    });
    
}

- (void)sendUploadStartedWithSize:(NSUInteger)size {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Progress
        [[self progressIndicator] setHidden:NO];
        [[self progressIndicator] setMaxValue:size];
        [[self progressIndicator] setDoubleValue:0];
        //FileItemView
        [[self fileItemView] setWithFile:self->file];
        // TODO: Status
    });
}

- (void)sendUploadProgressWithTotalBytesUploaded:(NSUInteger)bytes {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self progressIndicator] setDoubleValue:bytes];
    });
}

- (void)sendUploadCompleted {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", [self->send uploadedFileGetLink]);
        [[self resultView] setValuesForURL:[self->send uploadedFileGetLink]];
    });
}

@end
