//
//  Method.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "CommonMethod.h"

static CommonMethod *commonMethod;

@implementation CommonMethod


+ (id)share
{
    if (commonMethod) {
        return commonMethod;
    }
    commonMethod = [[CommonMethod alloc] init];
    return commonMethod;
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
