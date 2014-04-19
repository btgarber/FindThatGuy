//
//  ViewController.m
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "LoadingViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{

    NSString *ident = [User getDeviceIdentifier];
    if(ident == NULL)
    {
        [self performSegueWithIdentifier:@"register" sender:self];
    }
    else
    {
        PFQuery *query = [PFQuery queryWithClassName:@"USER"]; // 1
        [query getObjectInBackgroundWithId: ident block:^(PFObject  *pf, NSError *error) {
            User *user = [[User alloc] initWithPFObject:pf];
            [User sharedUser: user];
            
            [self performSegueWithIdentifier:@"mainView" sender:self];
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
