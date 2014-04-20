//
//  PlacesAnnotation.h
//  Maps
//
//  Created by philippe faucon on 3/5/13.
//  Copyright (c) 2013 philippe faucon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Location.h"
#import "DirectionManager.h"
#import "User.h"

@interface PlaceAnnotation : NSObject <MKAnnotation>

// Define the annotation properties
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) Location *placeInfo;

// store the location data
-(id)initWithInfo:(Location*)info;
@end
