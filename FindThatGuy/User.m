//
//  Settings.m
//  FindThatGuy
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import "User.h"
#import "Friend.h"

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

-(Friend*)hasFriend:(User*) user
{
    for (Friend *friend in self.friendLinks)
    {
        if([self.ident isEqualToString: [friend.user ident]])
            return friend;
    }
    return nil;
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
