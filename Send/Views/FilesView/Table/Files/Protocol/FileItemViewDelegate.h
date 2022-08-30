//
//  FileItemViewDelegate.h
//  Send
//

#import <Foundation/Foundation.h>

@protocol FileItemViewDelegate <NSObject>

@optional

- (void)fileItemDeletedWithIndex:(NSUInteger)index;

@end
