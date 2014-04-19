//
//  Settings.m
//  FindThatGuy
//
//  Created by Brentton Garber on 3/23/14.
//  Copyright (c) 2014 Ahbiya Harris and Brent Garber. All rights reserved.
//

#import "User.h"

@implementation User

static User* theUser = nil;

-(id)init
{
    if((self = [super init]) != nil)
    {
        
    }
    return self;
}

-(id)initWithPFObject:(PFObject*) pf
{
    if((self = [super init]) != nil)
    {
        self.firstname = [pf objectForKey: FIRSTNAME];
        self.lastname = [pf objectForKey: LASTNAME];
        self.phonenumber = [pf objectForKey: PHONENUMBER];
        self.email = [pf objectForKey: EMAIL];
    }
    return self;
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
