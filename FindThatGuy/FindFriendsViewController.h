//
//  FindFriendsViewController.h
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindFriendsViewController : UITableViewController

@property(nonatomic)NSMutableArray *friendsList;


@property (weak, nonatomic) IBOutlet UITextField *searchbox;
@end
