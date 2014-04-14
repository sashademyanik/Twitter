//
//  LoginTableViewController.h
//  WSUVMessageBoard
//
//  Created by Alexander Paul Demyanik on 4/11/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate <NSObject>

-(void)didCancelLogin;
-(void)didLogin;
@end

@interface LoginTableViewController : UITableViewController

@property (nonatomic) id loginDelegate;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;


@end
