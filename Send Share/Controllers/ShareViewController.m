//
//  ShareViewController.m
//  Send Share
//

#import "ShareViewController.h"

#import <Send_Library/Send.h>

@implementation ShareViewController {
    NSMutableArray<NSString *> *files;
    Send *send;
    BOOL fileUploaded;
}

- (NSString *)nibName {
    return @"ShareViewController";
}

- (void)loadView {
    [super loadView];
    
    self->files = [NSMutableArray new];
    
    self->send = [Send new];
    [self->send setDelegate:self];
    
    [[self progressIndicator] setHidden:YES];
    
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    for (NSItemProvider *attachment in [item attachments]) {
        if ([attachment hasItemConformingToTypeIdentifier:(NSString *)kUTTypeFileURL]) {
            [attachment loadItemForTypeIdentifier:(NSString *)kUTTypeFileURL options:nil completionHandler:^(__kindof id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                NSURL *url = [NSURL URLWithDataRepresentation:item relativeToURL:nil];
                [self->files addObject:[url path]];
            }];
        }
    }
}


- (void)sendUploadStartedWithSize:(NSUInteger)size {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Hide upload settings stack view
        [[self settingsStackView] setHidden:YES];
        // Show progress indicator
        [[self progressIndicator] setHidden:NO];
        [[self progressIndicator] setMaxValue:size];
        // Disable upload button
        [[self mainButton] setEnabled:NO];
    });
}

- (void)sendUploadProgressWithTotalBytesUploaded:(NSUInteger)bytes {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self progressIndicator] setDoubleValue:bytes];
    });
}

- (void)sendUploadCompletedWithStatus:(NSInteger)status {
    if (status == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [self->send uploadedFileGetLink];
            
            [[self resultView] setUrl:url];
            [[self resultView] setValues];
            [[self resultView] setHidden:NO];
            
            [[self mainButton] setEnabled:YES];
            [[self mainButton] setTitle:NSLocalizedString(@"Exit", @"Exit button")];
            self->fileUploaded = YES;
        });
    }
}

- (void)exitShareView {
    NSExtensionItem *outputItem = [[NSExtensionItem alloc] init];
    NSArray *outputItems = @[outputItem];
    [self.extensionContext completeRequestReturningItems:outputItems completionHandler:nil];
}

- (IBAction)send:(id)sender {
    if (self->fileUploaded) {
        [self exitShareView];
        return;
    }
    
    if ([self->files count] == 0) {
        [self exitShareView];
    }
    
    long long expiry = [[self settingsStackView] parseExpiry];
    unsigned char limit = [[self settingsStackView] parseLimit];
    NSString *password = [[self settingsStackView] parsePassword];
    
    [self->send setExpiry:expiry];
    [self->send setLimit:limit];
    if (password)
        [self->send setPassword:password];
    
    // Single file
    if ([self->files count] == 1) {
        NSString *path = [self->files objectAtIndex:0];
        // Start download
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self->send uploadFileWithPath:path];
        });
        return;
    }
    
    // Multiple files
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->send uploadFilesWithPaths:self->files tempFileCreatedAtBlock:^(NSString *path) {
            //AA
        }];
    });
    
    
}

- (IBAction)cancel:(id)sender {
    [self exitShareView];
}

@end

