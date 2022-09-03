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
        [[self layer] setBackgroundColor:[[NSColor colorNamed:@"colorFileItemView" bundle:nil] CGColor]];
    }
    return self;
}

- (void)deleteItem:(id)sender {
    [[self fileDelegate] fileItemDeletedWithIndex:[self index]];
}

- (void)setFileName:(NSString *)fileName setSize:(NSString *)fileSize setIsFolder:(BOOL)isFolder {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self fileName] setStringValue:fileName];
        [[self fileSize] setStringValue:fileSize];
        if (isFolder)
            [[self fileIcon] setImage:[NSImage imageNamed:@"folder"]];
        else
            [[self fileIcon] setImage:[NSImage imageNamed:@"doc"]];
    });
}

- (void)setupWithFile:(File *)file {
    NSString *fileName = [file name];
    NSString *fileSize = [file stringSize];
    BOOL isFolder = [file isFolder];
    
    [self setFileName:fileName setSize:fileSize setIsFolder:isFolder];
}

@end
