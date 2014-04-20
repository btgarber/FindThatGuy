//
//  DirectionManager.h
//  Assignment5
//
//  Created by Brentton Garber on 4/4/14.
//  Copyright (c) 2014 Brentton Garber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface DirectionManager : NSObject

// Define our shared function
+(DirectionManager*)sharedDirectionManager;

// Define our variables
@property (nonatomic,strong) Location *fromLocation;
@property (nonatomic,strong) Location *toLocation;

@end
