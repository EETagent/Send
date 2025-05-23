//
//  AppDelegate.m
//  Send
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpdaterController:[[SPUStandardUpdaterController alloc] initWithStartingUpdater:YES updaterDelegate:nil userDriverDelegate:nil]];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[self checkForUpdatesMenuItem] setTarget:[self updaterController]];
    [[self checkForUpdatesMenuItem] setAction:@selector(checkForUpdates:)];
    
    [[self finderShareExtensionMenuItem] setTarget:self];
    [[self finderShareExtensionMenuItem] setAction:@selector(openFinderShareExtensionSettings)];
}

- (void)openFinderShareExtensionSettings {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.ExtensionsPreferences?Sharing"]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    // Support Drag & Drop for application icon
    [[NSApplication sharedApplication] enumerateWindowsWithOptions:NSWindowListOrderedFrontToBack usingBlock:^(NSWindow * _Nonnull window, BOOL * _Nonnull stop) {
        NSViewController *viewController = [window contentViewController];
        SEL openPath = NSSelectorFromString(@"openPath:");
        // Check for openPath function in controller
        // Supported Controllers: WelcomeController / FilesViewController
        if ([viewController respondsToSelector:openPath]) {
            // No memory leak, openPath returns void
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [viewController performSelector:openPath withObject:filename];
            #pragma clang diagnostic pop
        }
    }];
    return YES;
}

- (IBAction)showSettings:(id)sender {
    // TODO: Better way
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSViewController *settingsViewController = [storyboard instantiateControllerWithIdentifier:@"SettingsTabView"];
    
    NSRect viewFrame = settingsViewController.view.frame;
    viewFrame.size.height = 250;
    settingsViewController.view.frame = viewFrame;
    
    NSWindow *keyWindow = [NSApplication sharedApplication].keyWindow;
    if (keyWindow && keyWindow.contentViewController) {
        [keyWindow.contentViewController presentViewControllerAsModalWindow:settingsViewController];
    }
}

@end
