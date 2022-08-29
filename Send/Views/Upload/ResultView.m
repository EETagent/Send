//
//  ResultView.m
//  Send
//

#import "ResultView.h"

#import <CoreImage/CoreImage.h>

@implementation ResultView

- (NSImage *)getQRCodeForURLString:(NSString *)urlString {
    NSData *stringData = [urlString dataUsingEncoding:NSISOLatin1StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    CIImage *image = [qrFilter outputImage];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(5.0f, 5.0f);
    
    CIImage *imageTransformed = [image imageByApplyingTransform: transform];
    
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:imageTransformed];
    
    NSImage *qrCode = [[NSImage alloc] initWithSize:rep.size];
    [qrCode addRepresentation:rep];
    
    return qrCode;
}



- (void)setValuesForURL:(NSURL *)url {
    [self setHidden:NO];
    
    NSString *urlString = [url absoluteString];
    
    [[self urlTextField] setStringValue:urlString];
    
    NSImage *qrCodeImage = [self getQRCodeForURLString:urlString];
    [[self qrcodeImage] setImage:qrCodeImage];
}

@end
