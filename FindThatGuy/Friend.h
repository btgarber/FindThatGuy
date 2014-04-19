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

@interface Friend : NSObject

typedef void (^FriendsLoadedBlock) ();

@property(nonatomic)NSString *ident;
@property(nonatomic)User *user;
@property(nonatomic)BOOL approved;


+(void)AddFriend:(NSString*)user withUser:(NSString*) link;
+(void)LoadFriends:(User*)user withCallback:(FriendsLoadedBlock) callback;
@end

