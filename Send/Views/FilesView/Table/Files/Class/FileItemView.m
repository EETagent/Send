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
        //#333333 or white
        [[self layer] setBackgroundColor:[[NSColor colorNamed:@"dragAndDrop" bundle:nil] CGColor]];
    }
    return self;
}

- (void)deleteItem:(id)sender {
    [[self fileDelegate] fileItemDeletedWithIndex:[self index]];
}

- (void)setFileName:(NSString *)fileName setSize:(NSString *)fileSize {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self fileName] setStringValue:fileName];
        [[self fileSize] setStringValue:fileSize];
    });
}

- (void)setupWithFile:(File *)file {
    NSString *fileName = [file name];
    NSString *fileSize = [file stringSize];
    [self setFileName:fileName setSize:fileSize];
}

@end
