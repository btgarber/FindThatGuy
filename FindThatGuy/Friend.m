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
        
        self.approved = NO;
    }
    return self;
}

-(User*)otherUser:(User*) user
{
    if([self.user1 equals: user])
        return self.user2;
    else return self.user1;
}

-(void)ApproveFriend
{
    PFObject *object = [PFObject objectWithoutDataWithClassName: FRIEND objectId: self.ident];
    self.approved = YES;
    [object setValue: [NSNumber numberWithBool:self.approved]  forKey: APPROVED];
    [object saveInBackground];
}



@end
