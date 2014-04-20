//
//  Location.m
//  Assignment5
//
//  Created by Brentton Garber on 4/4/2014.
//  Copyright (c) 2013 Brentton Garber. All rights reserved.
//

#import "Location.h"


@implementation Location

// initialize with coords
-(id)initCurrentLocation:(CLLocationCoordinate2D)coord {
    // call the superclass constructor, and make sure it succeeds
    self = [super init];
    
    if(self != nil) {
        self.name = @"Current Location";
        self.address = @"Current Location";
        self.location = coord;
    }
    return self;
}

// initialize with a placemark
-(id)initWithPlacemark:(MKPlacemark*)item {
    self = [super init];
    
    if(self != nil) {
        self.name = item.name;
        self.address = [Location locationFromPlacemark: item];
        self.location = item.location.coordinate;
    }
    return self;
}

// initialize with a placemark and a label name
-(id)initWithPlacemark:(MKPlacemark*)item withName:(NSString*)name {
    self = [super init];
    
    if(self != nil) {
        self.name = name;
        self.address = [Location locationFromPlacemark: item];
        self.location = item.location.coordinate;
    }
    return self;
}

// get the string location from a placemark
+(NSString*) locationFromPlacemark:(MKPlacemark*)item {
    NSArray *a = [item.addressDictionary objectForKey:@"FormattedAddressLines"];
    return [a componentsJoinedByString: @" "];
}

// check if the locations are the same
-(BOOL)equals:(Location*)loc {
    BOOL res = YES;
    if(self.location.latitude != loc.location.latitude) res = NO;
    if(self.location.longitude != loc.location.longitude) res = NO;
    return res;
}


@end
