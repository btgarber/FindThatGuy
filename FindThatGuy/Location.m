//
//  Location.m
//  Assignment5
//
//  Created by Brentton Garber on 4/4/2014.
//  Copyright (c) 2013 Brentton Garber. All rights reserved.
//

#import "Location.h"


@implementation Location

// initialize with a placemark
-(id)initWithPFObject:(PFObject *)object forUser:(User*) user {
    self = [super init];
    
    if(self != nil) {
        self.ident = [object objectId];
        self.user = user;
        self.address = nil;
        PFGeoPoint *geopoint = [object objectForKey: LOCATION];
        self.location = [[CLLocation alloc] initWithLatitude: geopoint.latitude longitude:geopoint.longitude];
    }
    return self;
}

-(id)initWithLocation:(CLLocation *)location forUser:(User*) user {
    self = [super init];
    
    if(self != nil) {
        self.ident = nil;
        self.user = user;
        self.address = nil;
        self.location = location;
    }
    return self;
}

-(void)save
{
    if(self.ident == nil)
    {
        PFGeoPoint *loc = [PFGeoPoint geoPointWithLocation: self.location];
        PFObject *object = [PFObject objectWithClassName: LOCATION];
        [object setObject: [PFObject objectWithoutDataWithClassName: USER objectId: self.user.ident] forKey: USER];
        [object setObject: loc forKey: LOCATION];
        if(self.address != nil)
            [object setObject: self.address forKey: ADDRESS];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.ident = [object objectId];
        }];
    }
    else
    {
        PFObject *object = [PFObject objectWithoutDataWithClassName: LOCATION objectId: self.ident];
        [object setObject: self.address forKey: ADDRESS];
        [object saveInBackground];
    }
}

// get the string location from a placemark
+(NSString*) locationFromPlacemark:(MKPlacemark*)item {
    NSArray *a = [item.addressDictionary objectForKey:@"FormattedAddressLines"];
    return [a componentsJoinedByString: @" "];
}


@end
