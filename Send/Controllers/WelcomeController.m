//
//  ViewController.m
//  Send
//

#import "WelcomeController.h"
#import "FilesViewController.h"

#import "File.h"

@implementation WelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)moveToFilesViewWithFiles:(NSArray<NSURL *> *)filesURL {
    NSMutableArray<File *> *files = [NSMutableArray new];
    for (NSURL *path in filesURL) {
        File *file = [[File alloc] initWithPath:path];
        [files addObject:file];
    }
    FilesViewController *controller = [[self storyboard] instantiateControllerWithIdentifier:@"FilesView"];
    [controller setFileList:files];
    [[[self view] window] setContentViewController:controller];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void)dropFilesAdded:(NSArray<NSURL *> *)files {
    [self moveToFilesViewWithFiles:files];
}

@end
