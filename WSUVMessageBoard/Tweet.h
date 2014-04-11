//
//  Tweet.h
//  WSUVMessageBoard
//
//  Created by Alexander Paul Demyanik on 4/8/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject //<NSCoding, NSCopying>

@property (assign, nonatomic) NSInteger tweet_id;
@property (copy, nonatomic) NSString *username;
@property (nonatomic) BOOL isdeleted;
@property (copy, nonatomic) NSString* tweet;
@property (retain, nonatomic) NSDate* date;
@property (copy, nonatomic) NSAttributedString* tweetAttributedString;

-(id)initWithTweetID:(NSInteger)tweet_ID
            Username:(NSString*) username
           IsDeleted:(BOOL)isdeleted
               Tweet:(NSString*)tweet
                Date:(NSDate*) date;
@end
