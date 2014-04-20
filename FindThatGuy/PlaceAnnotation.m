//
//  PlaceAnnotation.m
//  Maps
//
//  Created by philippe faucon on 3/5/13.
//  Copyright (c) 2013 philippe faucon. All rights reserved.
//

#import "PlaceAnnotation.h"

// For some folks' curiousity:
// How can I make properties, but have them be private?
// Here, we are adding an extension (unnamed category is the official term)
// to the PlaceAnnotation class, and adding the property to it.  Since
// this is not in any header file that is imported, it is only visible
// in the PlaceAnnotation.m scope.

@interface PlaceAnnotation ()

@end

@implementation PlaceAnnotation
@synthesize placeInfo = _placeInfo;

// initialize the annotation with a location
-(id)initWithInfo:(Location*)info {
	if (self = [super init]) {
		self.placeInfo = info;
	}
	return self;
}

// Instead of synthesizing this property, we're going to implement the getter ourselves!
-(CLLocationCoordinate2D) coordinate {
	return self.placeInfo.location.coordinate;
}

#pragma mark - protocol conformance methods
// these methods will be called by the map asking for our info
- (NSString *)title {
	return [self.placeInfo.user FullName];
}

// get the subtitle
- (NSString *)subtitle {
	return [NSString stringWithFormat:@"Latitude:%f Longitude:%f", self.placeInfo.location.coordinate.latitude, self.placeInfo.location.coordinate.longitude];
}

// when I am deallocated, I want to release my reference to the placeInfo
-(void) dealloc {
	self.placeInfo = nil;
}
@end
