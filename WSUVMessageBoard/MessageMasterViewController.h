//
//  MessageMasterViewController.h
//  WSUVMessageBoard
//
//  Created by Alexander Paul Demyanik on 4/1/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageDetailViewController;

@interface MessageMasterViewController : UITableViewController

@property (strong, nonatomic) MessageDetailViewController *detailViewController;

@end
