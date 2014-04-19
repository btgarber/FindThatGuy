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
    return [[[User sharedUser] friendLinks] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsListCell" forIndexPath:indexPath];
    
    Friend *friend = [[[User sharedUser] friendLinks] objectAtIndex:indexPath.row];
    [cell.name setText: [friend.user FullName]];
    [cell.city setText: [friend.approved description]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Unable to get GPS Fix." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

@end
