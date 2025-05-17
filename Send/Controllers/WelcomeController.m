//
//  ViewController.m
//  Send
//

#import "WelcomeController.h"
#import "FilesViewController.h"
#import "SettingsManager.h" // Import SettingsManager

#import "File.h"

@implementation WelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SettingsManager *settings = [SettingsManager sharedManager];
    double maxSizeGB = [settings maxFileSizeInGB];
    NSString *maxSizeString = [NSString stringWithFormat:@"%.1f GB", maxSizeGB];
    [[self maxSizeLabel] setStringValue:maxSizeString];
}

- (void)moveToFilesViewWithFiles:(NSArray<NSURL *> *)filesURL {
    NSMutableArray<File *> *files = [NSMutableArray new];
    for (NSURL *path in filesURL) {
        File *file = [[File alloc] initWithURLPath:path];
        [files addObject:file];
    }
    FilesViewController *controller = [[self storyboard] instantiateControllerWithIdentifier:@"FilesView"];
    
    [controller setFileList:files];
    
    CGRect frame = [[self view] frame];
    [[controller view] setFrame:frame];
    
    [[[self view] window] setContentViewController:controller];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void)dropFilesAdded:(NSArray<NSURL *> *)files {
    [self moveToFilesViewWithFiles:files];
}

- (void)openDocument:(id)sender {
    [[self dropView] openFile:sender];
}

- (void)openPath:(NSString *)path {
    NSArray<NSURL *> *array = [NSArray arrayWithObject:[NSURL fileURLWithPath:path]];
    [self moveToFilesViewWithFiles:array];
}

@end
