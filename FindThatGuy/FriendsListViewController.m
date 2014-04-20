//
//  FriendsListViewController.m
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "FriendsListViewController.h"

@interface FriendsListViewController ()

@end

@implementation FriendsListViewController

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
    self.title = [[User sharedUser] FullName];
    /*[Friend AddFriend:[[User sharedUser] ident] withUser:@"Y1s1Agw6Ej"];
    [Friend AddFriend:[[User sharedUser] ident] withUser:@"e9v2KFuIMr"];
    [Friend AddFriend:[[User sharedUser] ident] withUser:@"d8vBGkdiTj"];*/
    
    [[User sharedUser] loadFriends:^{
        [self.friendsTable reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.friendsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    User *user = [User sharedUser];
    int pending = (int)[[user PendingFriends] count];
    int approved = (int)[[user ApprovedFriends] count];
    if(approved > 0 && pending > 0)
        return 2;
    else if(approved > 0 || pending > 0)
        return 1;
    else return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    User *user = [User sharedUser];
    int pending = (int)[[user PendingFriends] count];
    int approved = (int)[[user ApprovedFriends] count];
    if(section == 0)
        return (pending > 0) ? pending : approved;
    else if(section == 1)
        return approved;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsListCell" forIndexPath:indexPath];
    Friend *friend = [self friendSelectedAt: indexPath];
    [cell.name setText: [[friend otherUser: [User sharedUser]] FullName]];
    if(friend.approved == false)
    {
        [cell.city setText: @"Tap to Confirm or Deny"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        [cell.city setText: [NSString stringWithFormat:@"%i", friend.approved]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Friend *friend = [self friendSelectedAt: indexPath];
    [[User sharedUser] setSelectedFriend: friend];
    
    if(friend.approved == false)
    {
        UIAlertView *confirmAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Confirm Friend"
                                   message: [NSString stringWithFormat: @"Would you like to confirm %@ as a friend?", [[friend otherUser: [User sharedUser]] FullName]]
                                   delegate: self
                                   cancelButtonTitle:@"Deny"
                                   otherButtonTitles:@"Confirm", nil];
        [confirmAlert show];
    }
    else
        [self performSegueWithIdentifier:@"UserMap" sender:self];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    User *user = [User sharedUser];
    if(buttonIndex == 0)
        [user RemoveFriend: [user.selectedFriend otherUser: [User sharedUser]]];
    else
        [user.selectedFriend ApproveFriend];
    [self.friendsTable reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    User *user = [User sharedUser];
    
    [label setText: ([[user PendingFriends] count] > 0 && section==0) ? @"Pending" : @"Approved"];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

-(Friend*)friendSelectedAt:(NSIndexPath *) indexPath {
    User *user = [User sharedUser];
    NSMutableArray *friends = nil;
    if(indexPath.section == 0)
    {
        friends = [[user PendingFriends] count] > 0 ? [user PendingFriends] : [user ApprovedFriends];
    }
    else
        friends = [user ApprovedFriends];
    
    return [friends objectAtIndex:indexPath.row];
}

@end
