//
//  AppDelegate.m
//  Send
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {}


- (void)applicationWillTerminate:(NSNotification *)aNotification {}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    NSLog(@"%@", filename);

    [[NSApplication sharedApplication] enumerateWindowsWithOptions:NSWindowListOrderedFrontToBack usingBlock:^(NSWindow * _Nonnull window, BOOL * _Nonnull stop) {
        NSViewController *viewController = [window contentViewController];
        SEL openPath = NSSelectorFromString(@"openPath:");
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

@end
