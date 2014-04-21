//
//  Location.h
//  Assignment5
//
//  Created by Brentton Garber on 4/4/2014.
//  Copyright (c) 2013 Brentton Garber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MKMapItem.h>
#import <Parse/Parse.h>
#import "User.h"

#define LOCATION @"LOCATION"
#define ADDRESS @"ADDRESS"

@interface Location : NSObject

// define our variables
@property (nonatomic, retain) NSString* ident;
@property (nonatomic, retain) User* user;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) CLLocation* location;

// define our functions
-(id)initWithPFObject:(PFObject *)object forUser:(User*) user;
-(id)initWithLocation:(CLLocation *)location forUser:(User*) user;
-(void)save;

+(NSString*) locationFromPlacemark:(MKPlacemark*)item;

@end
