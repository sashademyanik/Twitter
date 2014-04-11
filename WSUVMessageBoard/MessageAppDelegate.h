//
//  MessageAppDelegate.h
//  WSUVMessageBoard
//
//  Created by Alexander Paul Demyanik on 4/1/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"

@interface MessageAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *tweets;

-(NSDate*)lastTweetDate;

@end
