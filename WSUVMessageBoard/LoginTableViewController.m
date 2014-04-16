//
//  LoginTableViewController.m
//  WSUVMessageBoard
//
//  Created by Alexander Paul Demyanik on 4/11/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "LoginTableViewController.h"
#import "MessageAppDelegate.h"

#define BaseURLString @"https://bend.encs.vancouver.wsu.edu/~wcochran/cgi-bin/"

@interface LoginTableViewController ()

@end


@implementation LoginTableViewController{
    AFHTTPSessionManager *manager;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _logged = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelButton:(id)sender{
    [_loginDelegate didCancelLogin];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendLogin{
    [self.loginDelegate didLogin];
}

- (IBAction)loginButtonPressed:(id)sender {
    MessageAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"LoginButtonPressed");
    NSString *uname = self.usernameTextField.text;
    NSString *pword = self.passwordTextField.text;
    NSDictionary *parameters = @{@"username" : uname, @"password" : pword, @"action" : @"login"};
    //[self.loginDelegate didPressLogin:parameters];
    NSLog(@"Pressed Login");
    [manager POST:@"login.cgi"
       parameters:parameters
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              NSString *session = [responseObject objectForKey:@"session_token"];
              
              delegate.username = uname;
              delegate.password = pword;
              delegate.session_token = session;
              delegate.loginVar = 1;
              
              self.logged = YES;
              
            [self dismissView];
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              const int statuscode = response.statusCode;
              NSString *scode = [@(statuscode) stringValue];
              NSString *responseString;
              if (statuscode == 500){
                  responseString = @"Internal Server Error";
              }else if( statuscode == 400 ){
                  responseString = @"Bad Request";
              }else if (statuscode == 401){
                  responseString = @"Unauthorized";
              }else{
                  responseString = @"No such User";
              }
              
              
              
              UIAlertView *message = [[UIAlertView alloc] initWithTitle:scode
                                                                message:responseString
                                                               delegate:self
                                                      cancelButtonTitle:@"Sure?"
                                                      otherButtonTitles:nil];
              
              [message show];
              [self.refreshControl endRefreshing];
          }];
    [self sendLogin];

}

- (IBAction)registerButtonPressed:(id)sender {
    MessageAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    NSLog(@"RegisterButtonPressed");
    NSString *uname = self.usernameTextField.text;
    NSString *pword = self.passwordTextField.text;
    NSDictionary *parameters = @{@"username" : uname, @"password" : pword};
    
    NSLog(@"Pressed Register");
    [manager POST:@"register.cgi"
       parameters:parameters
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              NSString *session = [responseObject objectForKey:@"session_token"];
              
              delegate.username = uname;
              delegate.password = pword;
              delegate.session_token = session;
              delegate.loginVar = 1;
              [self.loginDelegate didLogin];
              
              [self dismissView];
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              const int statuscode = response.statusCode;
              NSString *scode = [@(statuscode) stringValue];
              NSString *responseString;
              if (statuscode == 500){
                  responseString = @"Internal Server Error";
              }else if( statuscode == 400 ){
                  responseString = @"Bad Request";
              }else{
                  responseString = @"Username already exists";
              }
              
              
              
              UIAlertView *message = [[UIAlertView alloc] initWithTitle:scode
                                                                message:responseString
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
              
              [message show];
              [self.refreshControl endRefreshing];
          }];

}

-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
 #pragma mark - Table view data source
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 #warning Potentially incomplete method implementation.
 // Return the number of sections.
 return 0;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 #warning Incomplete method implementation.
 // Return the number of rows in the section.
 return 0;
 }
 */
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 
 }
 */
@end
