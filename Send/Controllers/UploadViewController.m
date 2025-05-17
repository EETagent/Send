//
//  UploadViewController.m
//  Send
//

#import "UploadViewController.h"
#import "../Shared/SettingsManager.h"

#import <Send_Library/Send.h>

#import "../DockProgress/DockProgress.h"

@implementation UploadViewController {
    Send *send;
    File *file;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)returnToWelcome:(id)sender {
    NSViewController *controller = [[self storyboard] instantiateControllerWithIdentifier:@"WelcomeView"];
    
    CGRect frame = [[self view] frame];
    [[controller view] setFrame:frame];
    
    [[[self view] window] setContentViewController:controller];
}

- (void)uploadFiles:(NSArray<File *> *)files withExpiry:(long long)expiry withLimit:(unsigned char)limit withPassword:(NSString *)password {
    if ([files count] == 0)
        return;
    
    NSURL *sendURL = [[SettingsManager sharedManager] sendURL];
    self->send = [[Send alloc] initWithSendURL:[sendURL absoluteString]];
    [self->send setDelegate:self];
    
    [self->send setExpiry:expiry];
    [self->send setLimit:limit];
    
    if (password)
        [self->send setPassword:password];
    
    // Single file/folder
    if ([files count] == 1) {
        self->file = [files objectAtIndex:0];
        NSString *path = [self->file path];
        // Start download
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self->send uploadFileWithPath:path tempFileCreatedAtBlock:^(NSString *path) {
                // Update file with possible (if folder) ZIP location
                File *file = [[File alloc] initWithPath:path];
                self->file = file;
            }];
        });
        return;
    }
    
    // Multiple files/folders
    NSMutableArray<NSString *> *filePaths = [NSMutableArray new];
    // Map would be fancy
    for (File *file in files)
        [filePaths addObject:[file path]];
    // Start download
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self->send uploadFilesWithPaths:filePaths tempFileCreatedAtBlock:^(NSString *path) {
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
        [[self fileItemView] setupWithFile:self->file];
        [[self statusTextField] setStringValue:NSLocalizedString(@"Your files are currently being uploaded", @"Files uploading status")];
        [[self statusTextField] startAnimating];
    });
}

- (void)sendUploadProgressWithTotalBytesUploaded:(NSUInteger)bytes {
    // Update progress
    dispatch_async(dispatch_get_main_queue(), ^{
        double percent = bytes / [[self progressIndicator] maxValue];
        
        [DockProgress setProgress:percent];
        
        [[self progressIndicator] setDoubleValue:bytes];
    });
    
}

- (void)sendUploadCompleted {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *link = [self->send uploadedFileGetLink];
        if (link) {
            [[self resultView] setUrl:link];
            [[self resultView] setSuccess];
            [[self statusTextField] setStringValue:NSLocalizedString(@"Your file is encrypted and ready to send", @"Successful file upload status")];
            [[self statusTextField] stopAnimating];
        }
        
        [DockProgress hideProgress];
    });
}

- (void)sendUploadFailedWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self fileItemView] setHidden:YES];
        [[self statusTextField] setStringValue:[error localizedDescription]];
        [[self statusTextField] stopAnimating];
        
        [[self resultView] setError];
    });
}

@end
