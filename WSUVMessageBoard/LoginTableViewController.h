//
//  LoginTableViewController.h
//  WSUVMessageBoard
//
//  Created by Alexander Paul Demyanik on 4/11/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate <NSObject>
@optional
-(void)didCancelLogin;
-(void)didPressLogin:(NSDictionary*)parameters;
-(void)didPressRegister:(NSDictionary*)parameters;
-(void)didLogin;
@end

@interface LoginTableViewController : UITableViewController

@property (nonatomic) id<LoginDelegate> loginDelegate;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic) BOOL logged;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
-(void)sendLogin;
@end
