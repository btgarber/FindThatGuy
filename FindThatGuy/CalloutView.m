//
//  CalloutView.m
//  Assignment5
//
//  Created by Brentton Garber on 4/5/14.
//  Copyright (c) 2014 Brentton Garber. All rights reserved.
//

#import "CalloutView.h"

@implementation CalloutView

// initialize the callout frame
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// draw the callout
- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = 15.0;
    self.layer.masksToBounds = YES;

    double constrainedWidth = 200;
    if(self.name.attributedText.size.width > constrainedWidth) constrainedWidth = self.name.attributedText.size.width;
    if(self.address.attributedText.size.width > constrainedWidth) constrainedWidth = self.address.attributedText.size.width;
    [self setFrame: CGRectMake(self.frame.origin.x, self.frame.origin.y, constrainedWidth+16, self.frame.size.height) ];
}


@end
