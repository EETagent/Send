//
//  DropView.m
//  Send
//

#import "DropView.h"

#import <Quartz/Quartz.h>

@implementation DropView {
    NSTimer *timer;
    CGFloat dashedBorderPhase;

}

- (void)dealloc {
    [self->timer invalidate];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    const CGFloat dashHeight = 2;
    const CGFloat dashLength[] = {10, 5};
    
    NSColor *dashColor = [NSColor lightGrayColor];
    
    CGContextRef currentContext = [[NSGraphicsContext currentContext] CGContext];
    CGContextSetLineWidth(currentContext, dashHeight);
    CGContextSetLineDash(currentContext, self->dashedBorderPhase, dashLength, sizeof(dashLength) / sizeof(CGFloat));
    CGContextSetStrokeColorWithColor(currentContext, [dashColor CGColor]);
    
    CGContextAddRect(currentContext,CGRectInset(dirtyRect, dashHeight, dashHeight));
    
    CGContextStrokePath(currentContext);
    // Reset phsase counter
    // TODO: Investigate smooth transition
    if (self->dashedBorderPhase > 10000)
        self->dashedBorderPhase = 0;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        const float INTERVAL = 0.1f;
        self->timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL repeats:YES block:^(NSTimer * _Nonnull timer) {
            self->dashedBorderPhase++;
            [self setNeedsDisplay:YES];
        }];
        [self setWantsLayer:YES];
        // Rounded corners
        if (@available(macOS 10.15, *)) {
            [[self layer] setCornerCurve:kCACornerCurveContinuous];
        }
        [[self layer] setCornerRadius:6];
        //Background color
        //#333333
        [[self layer] setBackgroundColor:[[NSColor colorWithSRGBRed:0.2 green:0.2 blue:0.2 alpha:1] CGColor]];
    }
    return self;
}

@end
