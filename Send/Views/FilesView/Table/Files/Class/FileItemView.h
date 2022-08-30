//
//  FileItemView.h
//  Send
//

#import <Cocoa/Cocoa.h>

#import "FileItemViewDelegate.h"

#import "File.h"

@interface FileItemView : NSStackView

@property(nonatomic, weak) id <FileItemViewDelegate> fileDelegate;

@property NSUInteger index;

@property (nonatomic, weak) IBOutlet NSTextField *fileName;

@property (nonatomic, weak) IBOutlet NSTextField *fileSize;

- (IBAction)deleteItem:(id) sender;

- (void)setFileName:(NSString*)fileName setSize:(NSString*)size;

- (void)setupWithFile:(File *)file;

@end
