//
//  ViewController.m
//  Send
//

#import "WelcomeController.h"

@implementation WelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)move:(id)sender {
    NSViewController *controller = [[self storyboard] instantiateControllerWithIdentifier:@"FilesView"];
    [[[self view] window] setContentViewController:controller];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


@end
