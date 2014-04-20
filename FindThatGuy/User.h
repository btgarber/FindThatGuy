//
//  User.h
//  FindThatGuy
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Friend;

#define FIRSTNAME @"FIRSTNAME"
#define LASTNAME @"LASTNAME"
#define PHONENUMBER @"PHONENUMBER"
#define EMAIL @"EMAIL"
#define USER @"USER"

@interface User : NSObject

@property(nonatomic)NSString *ident;
@property(nonatomic)NSString *firstname;
@property(nonatomic)NSString *lastname;
@property(nonatomic)NSString *phonenumber;
@property(nonatomic)NSString *email;

@property(nonatomic)Friend *selectedFriend;

@property(nonatomic)NSMutableArray *friendLinks;

-(id)initWithPFObject:(PFObject*) pf;
-(PFObject*)GetPFObject;
-(NSString*)FullName;
-(Friend*)hasFriend:(User*) user;
-(Friend*)AddFriend:(User*)user;
-(void)RemoveFriend:(User*)user;
-(NSMutableArray*)PendingFriends;
-(NSMutableArray*)ApprovedFriends;
-(BOOL)isRegistered;


+(NSString*) getDeviceIdentifier;
+(void) setDeviceIdentifier:(NSString*) ident;
+(User*)sharedUser;
+(User*)sharedUser:(User*)user;

@end

