//
//  FindFriendsViewController.h
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

#define T_NAME 1
#define T_EMAIL 2
#define T_PHONE 3

@interface FindFriendsViewController : UIViewController <UISearchBarDelegate>

@property(nonatomic)NSMutableArray *friendsList;
@property(nonatomic)int searchType;

@property (weak, nonatomic) IBOutlet UITableView *resultsTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBox;

@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;



@end
