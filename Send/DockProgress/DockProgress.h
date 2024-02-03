//
//  DockProgress.h
//  Send
//  Ported from https://github.com/sindresorhus/DockProgress
//

#import <Cocoa/Cocoa.h>

@interface DockProgress : NSObject

@property (class, nonatomic, assign) double progress;

+ (void)resetProgress;
+ (void)hideProgress;

@end
