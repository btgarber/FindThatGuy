//
//  FriendsListViewController.h
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Friend.h"
#import "FriendsListCell.h"

@interface FriendsListViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *friendsTable;

@end
