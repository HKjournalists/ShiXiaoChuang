//
//  User.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "User.h"



static User *user;

@implementation User
{
}


+ (id)share
{
    if (user) {
        return user;
    }
    user = [[User alloc] init];


    return user;
}

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

@end
