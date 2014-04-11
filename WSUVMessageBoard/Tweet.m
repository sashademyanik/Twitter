//
//  Tweet.m
//  WSUVMessageBoard
//
//  Created by Alexander Paul Demyanik on 4/8/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

-(id) init {
	if ( self = [super init] ){
		self.tweet_id = -1;
		self.username = @"";
		self.isdeleted = NO;
		self.tweet = @"";
		self.date = [NSDate date];
		self.tweetAttributedString = nil;
	}
	return self;
}

-(id)initWithTweetID:(NSInteger)tweet_ID
            Username:(NSString*) username
           //IsDeleted:(BOOL)isdeleted
               Tweet:(NSString*)tweet
                Date:(NSDate*) date{
    if (self = [super init]) {
        self.tweet_id = tweet_ID;
		self.username = username;
		//self.isdeleted = isdeleted;
		self.tweet = tweet;
		self.date = date;
    }
    
    return self;
}


@end
