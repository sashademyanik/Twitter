//
//  AddTweetViewController.h
//  WSUVMessageBoard
//
//  Created by Alexander Paul Demyanik on 4/11/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTweetDelegate <NSObject>
@optional
-(void)didCancelAddTweet;
-(void)didAddTweet;
@end

@interface AddTweetViewController : UITableViewController <UITextViewDelegate>

@property (nonatomic) id addTweetDelegate;

@property (weak, nonatomic) IBOutlet UILabel *charactersTyped;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextField;


@end
