//
//  DropViewDelegate.h
//  Send
//

#import <Foundation/Foundation.h>

@protocol DropViewDelegate <NSObject>

@optional

- (void)dropViewFilesAdded:(NSArray<NSURL*>*)files;

@end
