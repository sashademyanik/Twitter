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
		self.tweetString = nil;
	}
	return self;
}

#define kTweetId @"tweet_id"
#define kUsername @"username"
#define kIsDeleted @"isdeleted"
#define kTweet @"tweet"
#define kDate @"date"
#define kTweetString @"tweetString"

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.tweet_id = [aDecoder decodeIntegerForKey:kTweetId];
        self.username = [aDecoder decodeObjectForKey:kUsername];
        self.isdeleted = [aDecoder decodeBoolForKey:kIsDeleted];
        self.tweet = [aDecoder decodeObjectForKey:kTweet];
        self.date = [aDecoder decodeObjectForKey:kDate];
        self.tweetString = [aDecoder decodeObjectForKey:kTweetString];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.tweet_id forKey:kTweetId];
    [aCoder encodeObject:self.username forKey:kUsername];
    [aCoder encodeBool:self.isdeleted forKey:kIsDeleted];
    
}

-(id)copyWithZone:(NSZone *)zone{
    Tweet *clone = [[[self class] alloc] init];
    
    return clone;
}

@end
