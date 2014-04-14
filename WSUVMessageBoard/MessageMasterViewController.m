//
//  MessageMasterViewController.m
//  WSUVMessageBoard
//
//  Created by Alexander Paul Demyanik on 4/1/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "MessageMasterViewController.h"
#import "MessageAppDelegate.h"
#import "MessageDetailViewController.h"
#import "Tweet.h"
#import "AddTweetViewController.h"
#import "LoginTableViewController.h"

#define BaseURLString @"https://bend.encs.vancouver.wsu.edu/~wcochran/cgi-bin/"

@interface MessageMasterViewController () <AddTweetDelegate, LoginDelegate> {
    MessageAppDelegate *delegate;
    NSMutableArray *_objects;
    AFHTTPSessionManager *manager;
}
@end

@implementation MessageMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (MessageDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    _objects = [[NSMutableArray alloc] init];
    delegate = [[UIApplication sharedApplication] delegate];
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTweets {
    //MessageAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    NSDate *lastTweetDate = [delegate lastTweetDate];
    NSString *dateStr = [dateFormatter stringFromDate:lastTweetDate];
    NSDictionary *parameters = @{@"date" : dateStr};
    
    
    
    [manager GET:@"get-tweets.cgi"
      parameters:parameters
         success: ^(NSURLSessionDataTask *task, id responseObject) {
             NSMutableArray *arrayOfDicts = [responseObject objectForKey:@"tweets"];
             //NSArray *temp = arrayOfDicts.mutableCopy;
             
             for (NSDictionary *t in arrayOfDicts) {
                 BOOL b;
                 if ([t objectForKey:@"isdeleted"]){
                     b = YES;
                 }else{
                     b = NO;
                 }
                 //if (b == NO){
                     NSInteger tInt = [[t objectForKey:@"tweet_id"] integerValue];
                     NSString *username = [t objectForKey:@"username"];
                 
                     NSString *tw = [t objectForKey:@"tweet"];
                     NSString *d = [t objectForKey:@"time_stamp"];
                     NSDate *date = [dateFormatter dateFromString:d];
                     Tweet *tweet = [[Tweet alloc] initWithTweetID:tInt
                                                      Username:username
                                                     IsDeleted:b Tweet:tw Date:date];
                     [self tweetAttributedStringFromTweet:tweet];
                     [delegate.tweets insertObject:tweet atIndex:0];
                     [_objects insertObject:tweet atIndex:0];
                 //}
                 
                 
             }

             [self.tableView reloadData];
             [self.refreshControl endRefreshing];
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             const int statuscode = response.statusCode;
             NSString *scode = [NSString stringWithFormat:@"%d",statuscode];
             NSString *responseString = [[NSString alloc] initWithData:(NSData*)response encoding:NSUTF8StringEncoding];
			 
			 UIAlertView *message = [[UIAlertView alloc] initWithTitle:scode
                                                               message:responseString
                                                              delegate:self
                                                     cancelButtonTitle:@"Sure?"
                                                     otherButtonTitles:nil];
             
			 [message show];
             [self.refreshControl endRefreshing];
         }];
}

-(IBAction)refreshControlValueChanged:(UIRefreshControl *) sender{
    [self refreshTweets];
}

#pragma Login Stuff

-(void)didCancelLogin{
    
}

-(void)didLogin{
    
    NSDictionary *parameters = @{@"username":delegate.username, @"password":delegate.password, @"action" : @"login"};
    
    [manager POST:@"login.cgi"
      parameters:parameters
         success: ^(NSURLSessionDataTask *task, id responseObject) {
             NSMutableArray *arrayOfDicts = [responseObject objectForKey:@"tweets"];
             //
             // Add new (sorted) tweets to head of appDelegate.tweets array.
             // If implementing delete, some older tweets may be purged.
             // Invoke [self.tableView reloadData] if any changes.
             //
             [self.refreshControl endRefreshing];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             const int statuscode = response.statusCode;
             NSString *scode = [NSString stringWithFormat:@"%d",statuscode];
             NSString *responseString = [[NSString alloc] initWithData:(NSData*)response encoding:NSUTF8StringEncoding];
			 
			 UIAlertView *message = [[UIAlertView alloc] initWithTitle:scode
                                                               message:responseString
                                                              delegate:self
                                                     cancelButtonTitle:@"Sure?"
                                                     otherButtonTitles:nil];
             
			 [message show];
             [self.refreshControl endRefreshing];
         }];
}

-(void)didAddTweet {
    [self.refreshControl beginRefreshing];
    [self refreshTweets];
}
-(void)didCancelAddTweet{
    
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [self performSegueWithIdentifier:@"AddTweetSegue" sender:self];
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(NSAttributedString*)tweetAttributedStringFromTweet:(Tweet*)tweet {
    if (tweet.tweetAttributedString == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        NSString *dateString = [dateFormatter stringFromDate:tweet.date];
        NSString *title = [NSString stringWithFormat:@"%@ - %@\n",
                           tweet.username, dateString];
        NSDictionary *titleAttributes =
  @{NSFontAttributeName : [UIFont systemFontOfSize:14],
    NSForegroundColorAttributeName: [UIColor blueColor]};
        NSMutableAttributedString *tweetWithAttributes =
        [[NSMutableAttributedString alloc] initWithString:title
                                               attributes:titleAttributes];
        NSMutableParagraphStyle *textStyle =
        [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *bodyAttributes =
  @{NSFontAttributeName : [UIFont systemFontOfSize:17],
    NSForegroundColorAttributeName: [UIColor blackColor],
    NSParagraphStyleAttributeName : textStyle};
        NSAttributedString *bodyWithAttributes =
        [[NSAttributedString alloc] initWithString:tweet.tweet
                                        attributes:bodyAttributes];
        [tweetWithAttributes appendAttributedString:bodyWithAttributes];
        tweet.tweetAttributedString = tweetWithAttributes;
    }
    return tweet.tweetAttributedString;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //MessageAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Tweet *tweet = delegate.tweets[indexPath.row];
    NSAttributedString *tweetAttributedString =
    [self tweetAttributedStringFromTweet:tweet];
    CGRect tweetRect =
    [tweetAttributedString
     boundingRectWithSize:CGSizeMake(self.tableView.bounds.size.width,1000.0)
     options:NSStringDrawingUsesLineFragmentOrigin
     context:nil];
    return ceilf(tweetRect.size.height) + 1 + 20; // add marginal space
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TwitterCell";
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                    forIndexPath:indexPath];
    //MessageAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Tweet *tweet = delegate.tweets[indexPath.row];
    NSAttributedString *tweetAttributedString =
    [self tweetAttributedStringFromTweet:tweet];
    cell.textLabel.numberOfLines = 0; // multi-line label
    cell.textLabel.attributedText = tweetAttributedString;
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//
//    NSDate *object = _objects[indexPath.row];
//    cell.textLabel.text = [object description];
//    return cell;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
    if ([segue.identifier isEqualToString:@"AddTweetSegue"]) {
        UINavigationController *navController =
        (UINavigationController*) segue.destinationViewController;
        AddTweetViewController *addTweetController =
        (AddTweetViewController*) navController.topViewController;
        addTweetController.addTweetDelegate = self;
    } else if ([segue.identifier isEqualToString:@"LoginSegue"]) {
        // no prep needed here
    }
}

@end
