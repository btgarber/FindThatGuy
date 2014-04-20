//
//  CalloutView.h
//  Assignment5
//
//  Created by Brentton Garber on 4/5/14.
//  Copyright (c) 2014 Brentton Garber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalloutView : UIView


// Define our outlets
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;

@end
