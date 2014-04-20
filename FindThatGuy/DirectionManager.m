//
//  DirectionManager.m
//  Assignment5
//
//  Created by Brentton Garber on 4/4/2014.
//  Copyright (c) 2014 Brentton Garber. All rights reserved.
//

#import "DirectionManager.h"

static DirectionManager *theManager;

@implementation DirectionManager

// Get the singleton object
+(DirectionManager*)sharedDirectionManager {
    @synchronized(self) {
        if(theManager == nil) {
            theManager = [[DirectionManager alloc] init];
        } }
    return theManager;
}

// Remember that init with no arguments is the default constructor.
// This is a convention of this library of objects.
-(id)init {
    // call the superclass constructor, and make sure it succeeds
    self = [super init];
    
    if(self != nil) {
  
    }
    return self;
}

@end
