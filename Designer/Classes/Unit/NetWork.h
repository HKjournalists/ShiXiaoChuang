//
//  NetWork.h
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//
#if H
#define PROJECT_NAME @"H"
#else
#define PROJECT_NAME @"D"
#endif


#import <Foundation/Foundation.h>



@interface NetWork : NSObject
{
    
}
@property(nonatomic ,assign) bool isConnect;
@property(nonatomic ,assign) bool isFirstLogin;


+ (id)shareNetWork;


- (BOOL)CheckNetwork;





@end
