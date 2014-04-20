//
//  FindFriendsViewController.m
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "FindFriendsViewController.h"

@interface FindFriendsViewController ()

@end

@implementation FindFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchType = T_NAME;
    self.friendsList = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBox resignFirstResponder];
    [self search: [self.searchBox text] withType:self.searchType];
}

- (IBAction)NameClicked:(id)sender {
    self.searchType = T_NAME;
    self.nameButton.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.95 alpha:1];
    self.emailButton.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.85 alpha:1];
    self.phoneButton.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.85 alpha:1];
}

- (IBAction)EmailClicked:(id)sender {
    self.searchType = T_EMAIL;
    self.nameButton.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.85 alpha:1];
    self.emailButton.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.95 alpha:1];
    self.phoneButton.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.85 alpha:1];
}

- (IBAction)PhoneClicked:(id)sender {
    self.searchType = T_PHONE;
    self.nameButton.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.85 alpha:1];
    self.emailButton.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.85 alpha:1];
    self.phoneButton.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.95 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindFriendsCell" forIndexPath:indexPath];
    User *result = [self.friendsList objectAtIndex:indexPath.row];
    Friend *friend = [[User sharedUser] hasFriend: result];
    
    [[cell name] setText: [result FullName]];
    
    if(friend == nil)
        [[cell status] setText: @""];
    else if(friend.approved == YES)
        [[cell status] setText: @"Approved"];
    else if(friend.approved == NO)
        [[cell status] setText: @"Pending"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [User sharedUser];
    User *result = [self.friendsList objectAtIndex:indexPath.row];
    Friend *friend = [user hasFriend: result];
    
    if(friend == nil)
        [user AddFriend: result];
    else
        [user RemoveFriend: result];
    
    [self.resultsTable reloadData];
}

-(void)search:(NSString*)searchText withType:(int)type
{
    PFQuery *query = nil;
    if(type == T_NAME) {
        NSMutableArray *queries = [[NSMutableArray alloc] init];
        for(NSString *part in [searchText componentsSeparatedByString:@" "])
        {
            PFQuery *sub_firstname = [PFQuery queryWithClassName: USER];
            PFQuery *sub_lastname = [PFQuery queryWithClassName: USER];
            [sub_firstname whereKey: FIRSTNAME matchesRegex:[NSString stringWithFormat:@".*%@.*", part]modifiers:@"i"];
            [sub_lastname whereKey: LASTNAME matchesRegex:[NSString stringWithFormat:@".*%@.*", part] modifiers:@"i"];
            [queries addObject: sub_firstname];
            [queries addObject: sub_lastname];
        }
        query = [PFQuery orQueryWithSubqueries: queries];
    }
    
    if(type == T_EMAIL) {
        query = [PFQuery queryWithClassName: USER];
        [query whereKey: EMAIL matchesRegex:[NSString stringWithFormat:@".*%@.*", searchText] modifiers:@"i"];
    }
    
    if(type == T_PHONE) {
        query = [PFQuery queryWithClassName: USER];
        [query whereKey: PHONENUMBER matchesRegex:[NSString stringWithFormat:@".*%@.*", searchText] modifiers:@"i"];
    }
    
    [query setLimit: 20];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.friendsList removeAllObjects];
        for(PFObject *pf in objects) {
            [self.friendsList addObject: [[User alloc] initWithPFObject:pf]];
        }
        [self.resultsTable reloadData];
    }];
    
}

@end
