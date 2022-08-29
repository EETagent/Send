//
//  FileItemView.m
//  Send
//

#import "FileItemView.h"

#import "../../../../../libzip/SSZipArchive/SSZipArchive.h"

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

- (void)setFileName:(NSString *)fileName setSize:(NSString *)fileSize {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self fileName] setStringValue:fileName];
        [[self fileSize] setStringValue:fileSize];
    });
}

- (void)setWithFile:(File *)file {
    NSString *fileName = [file filename];
    NSString *fileSize = [file stringSize];
    [self setFileName:fileName setSize:fileSize];
}

@end
