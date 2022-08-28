//
//  DropTableView.h
//  Send
//
//  Created by Vojtěch Jungmann on 28.08.2022.
//

#import <Cocoa/Cocoa.h>

#import "DropDelegate.h"

@interface DropTableView : NSTableView <NSTableViewDataSource>

@property (nonatomic, weak) IBOutlet id <NSTableViewDataSource> sourceDelegate;

@property (nonatomic, weak) IBOutlet id <DropDelegate> dropDelegate;

@end
