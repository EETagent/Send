//
//  ResultView.h
//  Send
//

#import <Cocoa/Cocoa.h>

@interface ResultView : NSStackView

@property(nonatomic, weak) IBOutlet NSTextField *urlTextField;

@property(nonatomic, weak) IBOutlet NSButton *qrcodeImage;

@property(nonatomic, weak) IBOutlet NSButton *returnButton;

@property(nonatomic, weak) IBOutlet NSButton *linkCopyButton;


@property NSURL *url;

- (void)setSuccess;

- (void)setError;

- (IBAction)copyQrCode:(id)sender;

- (IBAction)copyURL:(id)sender;

@end
