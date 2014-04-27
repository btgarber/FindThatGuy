//
//  Friend.m
//  FindThatGuy
//
//  Created by Brentton Garber on 4/18/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "Friend.h"
#import "User.h"

@implementation Friend

-(id)init
{
    if((self = [super init]) != nil)
    {
        self.user1 = nil;
        self.user2 = nil;
        self.approved = NO;
    }
    return self;
}

-(id)initForUser:(User*) user withFriend:(User*) friend
{
    if((self = [super init]) != nil)
    {
        self.user1 = user;
        self.user2 = friend;
        self.approved = NO;
    }
    return self;
}

-(id)initWithPFObject:(PFObject*) object forUser:(User*) user
{
    if((self = [super init]) != nil)
    {
        self.ident = [object objectId];
        self.user1 = [[User alloc] initWithPFObject: [object objectForKey: USER1]];
        self.user2 = [[User alloc] initWithPFObject: [object objectForKey: USER2]];
        self.approved = [[object objectForKey: APPROVED] boolValue];
    }
    return self;
}

-(User*)otherUser:(User*) user
{
    if([self.user1 equals: user])
        return self.user2;
    else return self.user1;
}

-(BOOL)isPrimary:(User*) user
{
    return [self.user1 equals: user];
}

-(void)ApproveFriend:(User*)user
{
    PFObject *object = [PFObject objectWithoutDataWithClassName: FRIEND objectId: self.ident];
    self.approved = YES;
    [object setValue: [NSNumber numberWithBool:self.approved]  forKey: APPROVED];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        PFQuery *pushQuery = [PFInstallation query];
        PFPush *push = [[PFPush alloc] init];
        [pushQuery whereKey:@"user" equalTo: [[self otherUser:user] ident]];
        [push setQuery: pushQuery];
        [data setObject:PUSH_FRIEND_APPROVED forKey:@"command"];
        [data setObject:[NSString stringWithFormat:@"%@ approved your friend request!", [user FullName]] forKey:@"alert"];
        [push setData: data];
        [push sendPushInBackground];
    }];
}



@end
