//
//  Settings.m
//  FindThatGuy
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import "User.h"
#import "Friend.h"
#import "Location.h"

@implementation User

static User* theUser = nil;

-(id)init
{
    if((self = [super init]) != nil)
    {
        self.friendLinks = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithPFObject:(PFObject*) pf
{
    if((self = [super init]) != nil)
    {
        self.ident = [pf objectId];
        self.firstname = [pf objectForKey: FIRSTNAME];
        self.lastname = [pf objectForKey: LASTNAME];
        self.phonenumber = [pf objectForKey: PHONENUMBER];
        self.email = [pf objectForKey: EMAIL];
        self.friendLinks = [[NSMutableArray alloc] init];
    }
    return self;
}

-(PFObject*)GetPFObject {
    PFObject *object = [PFObject objectWithClassName: USER]; // 1
    [object setValue: self.firstname forKey: FIRSTNAME];
    [object setValue: self.lastname forKey: LASTNAME];
    [object setValue: self.phonenumber forKey: PHONENUMBER];
    [object setValue: self.email forKey: EMAIL];
    return object;
}

-(NSString*)FullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
}

-(NSMutableArray*)PendingFriends
{
    NSMutableArray *pending = [[NSMutableArray alloc] init];
    for(Friend *friend in self.friendLinks)
    {
        if(friend.approved == NO)
            [pending addObject:friend];
    }
    return pending;
}

-(NSMutableArray*)ApprovedFriends
{
    NSMutableArray *approved = [[NSMutableArray alloc] init];
    for(Friend *friend in self.friendLinks)
    {
        if(friend.approved == YES)
            [approved addObject:friend];
    }
    return approved;
}

-(Friend*)hasFriend:(User*) user
{
    for (Friend *friend in self.friendLinks)
    {
        if([[friend otherUser: self] equals: user])
            return friend;
    }
    return nil;
}

-(Friend*)AddFriend:(User*)user
{
    Friend *friend = [[Friend alloc] initForUser: self withFriend: user];
    
    PFObject *object = [PFObject objectWithClassName: FRIEND];
    [object setValue: [PFObject objectWithoutDataWithClassName: USER objectId: self.ident] forKey: USER1];
    [object setValue: [PFObject objectWithoutDataWithClassName: USER objectId: [user ident]] forKey: USER2];
    [object setValue: [NSNumber numberWithBool:NO]  forKey: APPROVED];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        friend.ident = [object objectId];
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        PFQuery *pushQuery = [PFInstallation query];
        PFPush *push = [[PFPush alloc] init];
        [pushQuery whereKey:@"user" equalTo: [user ident]];
        [push setQuery: pushQuery];
        [data setObject:PUSH_FRIEND_ADDED forKey:@"command"];
        [data setObject:[NSString stringWithFormat:@"%@ just added you as a friend!", [self FullName]] forKey:@"alert"];
        [push setData: data];
        [push sendPushInBackground];
    }];

    [self.friendLinks addObject: friend];
    return friend;
}

-(void)RemoveFriend:(User*)user
{
    Friend *friend = [self hasFriend: user];
    if(friend == nil) return;
    
    PFQuery *query1 = [PFQuery queryWithClassName: FRIEND];
    PFQuery *query2 = [PFQuery queryWithClassName: FRIEND];
    
    [query1 whereKey: USER1 equalTo:[PFObject objectWithoutDataWithClassName: USER objectId: self.ident]];
    [query2 whereKey: USER1 equalTo:[PFObject objectWithoutDataWithClassName: USER objectId: user.ident]];
    [query1 whereKey: USER2 equalTo:[PFObject objectWithoutDataWithClassName: USER objectId: user.ident]];
    [query2 whereKey: USER2 equalTo:[PFObject objectWithoutDataWithClassName: USER objectId: self.ident]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:query1,query2,nil]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(PFObject *object in objects) {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                PFQuery *pushQuery = [PFInstallation query];
                PFPush *push = [[PFPush alloc] init];
                [pushQuery whereKey:@"user" equalTo: [user ident]];
                [push setQuery: pushQuery];
                [push setData: [NSDictionary dictionaryWithObject:PUSH_FRIEND_REMOVED forKey:@"command"]];
                [push sendPushInBackground];
            }];
        }
    }];
    
    [self.friendLinks removeObject: friend];
}

-(BOOL)isRegistered
{
    return (self.ident != nil);
}

-(void)loadFriends:(FriendsLoadedBlock) callback
{
    PFQuery *q1 = [PFQuery queryWithClassName: FRIEND];
    PFQuery *q2 = [PFQuery queryWithClassName: FRIEND];
    
    [q1 whereKey: USER1 equalTo: [PFObject objectWithoutDataWithClassName: USER objectId: self.ident]];
    [q2 whereKey: USER2 equalTo: [PFObject objectWithoutDataWithClassName: USER objectId: self.ident]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:q1,q2, nil]];
    
    [query includeKey: USER1];
    [query includeKey: USER2];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.friendLinks removeAllObjects];
        for(PFObject *object in objects)
        {
            Friend *friend = [[Friend alloc] initWithPFObject: object forUser: self];
            [self.friendLinks addObject: friend];
            
        }
        if(callback != nil)
            callback();
    }];
}

-(BOOL)equals:(User*) user
{
    return (self.ident != nil && [self.ident isEqualToString: user.ident]);
}

-(void)loadCurrentLocation:(LocationLoadedBlock)callback
{
    PFQuery *query = [PFQuery queryWithClassName: LOCATION];
    [query whereKey: USER equalTo: [PFObject objectWithoutDataWithClassName: USER objectId: self.ident]];
    [query orderByDescending:@"updatedAt"];
    [query setLimit:1];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count] < 1) return;
        self.currentLocation = [[Location alloc] initWithPFObject: [objects objectAtIndex: 0] forUser:self];
        callback(self);
    }];
}

+(User*)sharedUser {
    if(theUser == nil) {
        theUser = [[User alloc] init];
    }
    return theUser;
}

+(User*)sharedUser:(User*)user
{
    return theUser = user;
}

+(NSString*) getDeviceIdentifier
{
    NSString *path = [@"~/Documents/ident.dat" stringByStandardizingPath];
    NSString *ident = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        ident = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return ident;
}

+(void) setDeviceIdentifier:(NSString*) ident
{
    NSString *path = [@"~/Documents/ident.dat" stringByStandardizingPath];
    NSData *data = [ident dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:path atomically:YES];
}




@end
