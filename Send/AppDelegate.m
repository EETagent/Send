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
    return YES;
}

@end
