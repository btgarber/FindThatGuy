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

-(void)ApproveFriend
{
    PFObject *object = [PFObject objectWithoutDataWithClassName: USER objectId: self.ident];
    [object setValue: [NSNumber numberWithBool:YES]  forKey: APPROVED];
    [object saveInBackground];
}

+(void)AddFriend:(NSString*)user withUser:(NSString*) link
{
    PFObject *object1 = [PFObject objectWithClassName: FRIEND];
    [object1 setValue: [PFObject objectWithoutDataWithClassName: USER objectId: user] forKey: USER];
    [object1 setValue: [PFObject objectWithoutDataWithClassName: USER objectId: link] forKey: FRIEND];
    [object1 setValue: [NSNumber numberWithBool:NO]  forKey: APPROVED];
    [object1 saveInBackground];
    
    PFObject *object2 = [PFObject objectWithClassName: FRIEND];
    [object2 setValue: [PFObject objectWithoutDataWithClassName: USER objectId: link] forKey: USER];
    [object2 setValue: [PFObject objectWithoutDataWithClassName: USER objectId: user] forKey: FRIEND];
    [object2 setValue: [NSNumber numberWithBool:YES]  forKey: APPROVED];
    [object2 saveInBackground];
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
