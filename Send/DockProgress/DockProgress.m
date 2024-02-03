//
//  DockProgress.m
//  Send
//  Ported from https://github.com/sindresorhus/DockProgress
//

#import <Cocoa/Cocoa.h>

#import "DockProgress.h"

@implementation DockProgress

+ (void)initialize {
    if (self == [DockProgress self]) {
        [self setDockImageView:[NSImageView new]];
        [[NSApp dockTile] setContentView:[self dockImageView]];
    }
}

static NSImageView *_dockImageView;

+ (NSImageView *)dockImageView {
    return _dockImageView;
}

+ (void)setDockImageView:(NSImageView *)dockImageView {
    _dockImageView = dockImageView;
}
                             
static double _previousProgress = 0;
static double _progress = 0;

+ (double)progress {
    return _progress;
}

+ (void)setProgress:(double)progress {
    if (_previousProgress == 0 || fabs(progress - _previousProgress) > 0.01) {
        _previousProgress = progress;
        [self updateDockIcon];
    }
    _progress = progress;
}

+ (void)resetProgress {
    _progress = 0;
    _previousProgress = 0;
    [self updateDockIcon];
}

+ (void)hideProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSImage *appIcon = [[NSApplication sharedApplication] applicationIconImage];
                
        [_dockImageView setImage:appIcon];
        
        [[NSApp dockTile] display];
    });
}


+ (void)updateDockIcon {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSImage *appIcon = [[NSApplication sharedApplication] applicationIconImage];

        NSImage *icon = (_progress >= 0 && _progress < 1) ? [self draw:appIcon] : appIcon;

        [_dockImageView setImage:icon];

        [[NSApp dockTile] display];
    });
}

+ (NSImage *)draw:(NSImage *)appIcon {
    NSImage *newImage = [[NSImage alloc] initWithSize:appIcon.size];
    [newImage lockFocusFlipped:NO];
    
    [NSGraphicsContext.currentContext setImageInterpolation:NSImageInterpolationHigh];
    [appIcon drawInRect:NSMakeRect(0, 0, newImage.size.width, newImage.size.height)];
    
    [self drawProgressBar:NSMakeRect(0, 0, newImage.size.width, newImage.size.height)];
    
    [newImage unlockFocus];
    
    return newImage;
}

+ (void)drawProgressBar:(CGRect)dstRect {
    void (^roundedRect)(CGRect) = ^(CGRect rect) {
        [[NSBezierPath bezierPathWithRoundedRect:rect xRadius:rect.size.height / 2 yRadius:rect.size.height / 2] fill];
    };

    CGRect bar = CGRectMake(0, 20, dstRect.size.width, 10);
    [[NSColor colorWithWhite:1.0 alpha:0.8] set];
    roundedRect(bar);

    CGRect barInnerBg = CGRectInset(bar, 0.5, 0.5);
    [[NSColor colorWithWhite:0.0 alpha:0.8] set];
    roundedRect(barInnerBg);

    CGRect barProgress = CGRectInset(bar, 1, 1);
    barProgress.size.width = barProgress.size.width * _progress;
    [[NSColor whiteColor] set];
    roundedRect(barProgress);
}

@end
