//
//  Settings.h
//  FindThatGuy
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property(nonatomic)NSString *firstname;
@property(nonatomic)NSString *lastname;
@property(nonatomic)NSString *phonenumber;
@property(nonatomic)NSString *email;



-(NSString*) getDeviceIdentifier;
-(void) setDeviceIdentifier:(NSString*) ident;
+(Settings*)sharedSettings;

@end
