//
//  AppDelegate.h
//  Send
//

#import <Cocoa/Cocoa.h>
#import <Sparkle/Sparkle.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(nonatomic, weak) IBOutlet NSMenuItem *checkForUpdatesMenuItem;
@property(nonatomic, weak) IBOutlet NSMenuItem *finderShareExtensionMenuItem;

@property SPUStandardUpdaterController *updaterController;

@end

