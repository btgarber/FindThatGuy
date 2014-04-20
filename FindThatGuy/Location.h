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


@interface Location : NSObject

// define our variables
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic) CLLocationCoordinate2D location;

// define our functions
-(id)initCurrentLocation:(CLLocationCoordinate2D)coord;
-(id)initWithPlacemark:(MKPlacemark*)item;
-(id)initWithPlacemark:(MKPlacemark*)item withName:(NSString*)name;
-(BOOL)equals:(Location*)loc;

+(NSString*) locationFromPlacemark:(MKPlacemark*)item;

@end
