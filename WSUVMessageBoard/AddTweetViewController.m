//
//  AddTweetViewController.m
//  WSUVMessageBoard
//
//  Created by Alexander Paul Demyanik on 4/11/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "AddTweetViewController.h"
#import "LoginTableViewController.h"
#import "MessageAppDelegate.h"
#define BaseURLString @"https://bend.encs.vancouver.wsu.edu/~wcochran/cgi-bin/"
@interface AddTweetViewController ()

@end

@implementation AddTweetViewController{
    AFHTTPSessionManager *manager;
    BOOL tooManyChars;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    //MessageAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweetTextField.delegate = self;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAdding)];
    self.navigationItem.rightBarButtonItem = doneButton;
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    tooManyChars = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)textViewDidChange:(UITextView *) textView {
    int thing = [self.tweetTextField.text length];
    self.charactersTyped.text = [NSString stringWithFormat:@"%d/140",thing];
    if (thing > 140){
        tooManyChars = YES;
    }else{
        tooManyChars = NO;
    }
}

-(void)doneAdding{
    if (tooManyChars) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"Too many characters! Only 140 characters allowed!"
                                                     delegate:self
                                            cancelButtonTitle:@"Fine..."
                                            otherButtonTitles:nil];
    
        [message show];
    }else{

    MessageAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *parameters = @{@"username" : delegate.username, @"session_token" : delegate.session_token, @"tweet" : self.tweetTextField.text};
    
    [manager POST:@"add-tweet.cgi"
       parameters:parameters
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              NSString *tweet = [responseObject objectForKey:@"tweet"];
              
              NSLog(@"Tweeting");
              
              
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              const int statuscode = response.statusCode;
              NSString *scode = [@(statuscode) stringValue];
              NSString *responseString;
              if (statuscode == 500){
                  responseString = @"Internal Server Error: Woops";
              }else if( statuscode == 400 ){
                  responseString = @"Bad Request: Params not provided";
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
/*
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
