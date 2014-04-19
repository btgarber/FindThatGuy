//
//  User.h
//  FindThatGuy
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define FIRSTNAME @"FIRSTNAME"
#define LASTNAME @"LASTNAME"
#define PHONENUMBER @"PHONENUMBER"
#define EMAIL @"EMAIL"

@interface User : NSObject

@property(nonatomic)NSString *firstname;
@property(nonatomic)NSString *lastname;
@property(nonatomic)NSString *phonenumber;
@property(nonatomic)NSString *email;

-(id)initWithPFObject:(PFObject*) pf;

+(NSString*) getDeviceIdentifier;
+(void) setDeviceIdentifier:(NSString*) ident;
+(User*)sharedUser;
+(User*)sharedUser:(User*)user;

@end
