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
    
    [Friend LoadFriends: [User sharedUser] withCallback:^{
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
    if(section == 0)
        return [[user PendingFriends] count];
    else if(section == 1)
        return [[user ApprovedFriends] count];
    else return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsListCell" forIndexPath:indexPath];
    Friend *friend = [self friendSelectedAt: indexPath];
    [cell.name setText: [friend.user FullName]];
    [cell.city setText: [NSString stringWithFormat:@"%i", friend.approved]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[User sharedUser] setSelectedFriend: [self friendSelectedAt: indexPath]];
    [self performSegueWithIdentifier:@"UserMap" sender:self];
}

-(Friend*)friendSelectedAt:(NSIndexPath *) indexPath {
    User *user = [User sharedUser];
    NSMutableArray *friends = nil;
    if(indexPath.section == 0)
        friends = [user PendingFriends];
    else
        friends = [user ApprovedFriends];
    
    return [friends objectAtIndex:indexPath.row];
}

@end
