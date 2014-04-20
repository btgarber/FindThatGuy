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
        self.user = nil;
        self.approved = NO;
    }
    return self;
}

-(id)initWithUser:(User*) user
{
    if((self = [super init]) != nil)
    {
        self.user = user;
        self.approved = NO;
    }
    return self;
}

-(void)ApproveFriend
{
    PFObject *object = [PFObject objectWithoutDataWithClassName: USER objectId: self.ident];
    [object setValue: [NSNumber numberWithBool:YES]  forKey: APPROVED];
    [object saveInBackground];
}

+(void)LoadFriends:(User*)user withCallback:(FriendsLoadedBlock) callback
{
    PFQuery *query = [PFQuery queryWithClassName: FRIEND];
    [query whereKey: USER equalTo: [PFObject objectWithoutDataWithClassName: USER objectId: [user ident]]];
    [query includeKey: FRIEND];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for(PFObject *object in objects)
        {
            Friend *friend = [[Friend alloc] init];
            [friend setIdent: [object objectId]];
            [friend setUser: [[User alloc] initWithPFObject: [object objectForKey: FRIEND]]];
            [friend setApproved: [[object objectForKey: APPROVED] boolValue]];
            [user.friendLinks addObject: friend];
        }
        if(callback != nil) callback();
    }];
}



@end
