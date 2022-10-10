//
//  AppDelegate.h
//  Send
//

#import <Cocoa/Cocoa.h>
#import <Sparkle/Sparkle.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(nonatomic, weak) IBOutlet NSMenuItem *checkForUpdatesMenuItem;

@property SPUStandardUpdaterController *updaterController;

@end

