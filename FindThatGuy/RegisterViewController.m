//
//  RegisterViewController.m
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    // Do any additional setup after loading the view.
}

- (IBAction)RegisterClicked:(id)sender {
    User *user = [User sharedUser];
    [user setFirstname: self.firstname.text];
    [user setLastname: self.lastname.text];
    [user setPhonenumber: self.phonenumber.text];
    [user setEmail: self.email.text];
    
    PFObject *pfUser = [user GetPFObject];
    [pfUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [user setIdent: [pfUser objectId]];
        [User setDeviceIdentifier: [user ident]];
        
        [self performSegueWithIdentifier:@"forwardToMainView" sender:self];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
