//
//  NetWork.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "NetWork.h"
#import "Reachability.h"


static NetWork *netWork;
@implementation NetWork

@synthesize isConnect = _isConnect;

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}


+ (id)shareNetWork
{
    if (netWork) {
        return netWork;
    }
    netWork = [[NetWork alloc] init];
    return netWork;
}


-(BOOL)CheckNetwork   {
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    NetworkStatus networkStatus = [reach currentReachabilityStatus];
    
    if ( networkStatus == NotReachable ) {
        _isConnect = NO;
        return NO;
    }
    else {
        _isConnect = YES;
        return YES;
    }
    return YES;
}






@end
