//
//  ResultView.h
//  Send
//

#import <Cocoa/Cocoa.h>

@interface ResultView : NSStackView

@property(nonatomic, weak) IBOutlet NSTextField *urlTextField;

@property(nonatomic, weak) IBOutlet NSButton *qrcodeImage;

@property NSURL *url;

- (void)setValues;

- (IBAction)copyQrCode:(id)sender;

- (IBAction)copyURL:(id)sender;

@end
