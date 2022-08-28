//
//  DropViewDelegate.h
//  Send
//

#import <Foundation/Foundation.h>

@protocol DropDelegate <NSObject>

@optional

- (void)dropFilesAdded:(NSArray<NSURL *> *)files;

@end
