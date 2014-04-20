//
//  Friend.h
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class User;

#define FRIEND @"FRIEND"
#define APPROVED @"APPROVED"
#define USER1 @"USER1"
#define USER2 @"USER2"

@interface Friend : NSObject

@property(nonatomic)NSString *ident;
@property(nonatomic)User *user1;
@property(nonatomic)User *user2;
@property(nonatomic)BOOL approved;

-(id)initForUser:(User*) user withFriend:(User*) friend;
-(id)initWithPFObject:(PFObject*) object forUser:(User*) user;
-(void)ApproveFriend;
-(User*)otherUser:(User*) user;
@end

