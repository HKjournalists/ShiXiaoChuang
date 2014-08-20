//
//  Cookie.h
//  M32
//
//  Created by i-Bejoy on 13-12-6.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cookie : NSObject


+ (id)getCookie:(NSString *)keyName;
+ (void)setCookie:(NSString *)keyName value:(id)value;


@end