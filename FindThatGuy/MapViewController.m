//
//  MapViewController.m
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle: [[[[User sharedUser] selectedFriend] user] FullName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Define our default annotation id
static NSString *viewId = @"MKPinAnnotationView";

// this gets called when a pin should appear on the screen
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // Get our Direction Manager Singleton Object
    DirectionManager *manager = [DirectionManager sharedDirectionManager];
    
    // Get the reusable annotation view
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
    
    // if a view does not exist, create a new one
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:viewId];
    }
    
    // Place the annotation in the annotation view
    annotationView.annotation = annotation;
    annotationView.canShowCallout = NO;
    
    // Set the pin color
    annotationView.pinColor = (((PlaceAnnotation*)annotation).placeInfo == manager.fromLocation) ? MKPinAnnotationColorPurple : MKPinAnnotationColorGreen;
    
    // Set the pin image
    annotationView.image = (((PlaceAnnotation*)annotation).placeInfo == manager.fromLocation) ? [UIImage imageNamed:@"route-start.png"]: [UIImage imageNamed:@"route-stop.png"];
    
    // Return the annotation
    return annotationView;
}

// this gets called when a pin is selected, the pin has a callout, and the map wants the callout
- (void)mapView:(MKMapView *)sender didSelectAnnotationView:(MKAnnotationView *)aView
{
    // if the annotation is not a MKUserLocation class
    if(![aView.annotation isKindOfClass:[MKUserLocation class]]) {
        
        // Get the annotation
        PlaceAnnotation *a = [aView annotation];
        
        // Create the new callout view
        CalloutView *calloutView = (CalloutView *)[[[NSBundle mainBundle] loadNibNamed:@"CalloutView" owner:self options:nil] objectAtIndex:0];
        
        // Setup the callout
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        
        // Change the values on the callout
        [calloutView.name setText: a.title];
        [calloutView.address setText:a.placeInfo.address];
        [calloutView.longitude setText: [NSString stringWithFormat:@"%f", a.placeInfo.location.longitude]];
        [calloutView.latitude setText: [NSString stringWithFormat:@"%f", a.placeInfo.location.latitude]];
        
        // Add the callout to the annotation view
        [aView addSubview:calloutView];
    }
}

// Create a polyline for the directions
- (void)findDirectionsFrom:(MKMapItem *)source to:(MKMapItem *)destination
{
    // Create our directions request
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // Receive the directions
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
         if (error) {
             NSLog(@"error:%@", error);
         }
         else {
             // Create the route polyline
             MKRoute *route = response.routes[0];
             [self.mapView addOverlay:route.polyline];
         }
     }];
}

// When the annotation view is deselected
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    // Remove the subviews
    for (UIView *subview in view.subviews ){
        [subview removeFromSuperview];
    }
}

#pragma mark - MKMapViewDelegate

// Render the new map overlay
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    // Render the polyline to the map
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = [UIColor greenColor];
    return renderer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
