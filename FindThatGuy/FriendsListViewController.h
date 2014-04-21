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
#import "Location.h"

@interface FriendsListViewController : UITableViewController <UIAlertViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *friendsTable;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
