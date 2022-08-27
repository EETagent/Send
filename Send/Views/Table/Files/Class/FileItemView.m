//
//  FileItemView.m
//  Send
//

#import "FileItemView.h"

@implementation FileItemView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setWantsLayer:YES];
        // Rounded border
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

- (void)deleteItem:(id)sender {
    [[self fileDelegate] fileItemDeletedWithIndex:[self index]];
}

@end
