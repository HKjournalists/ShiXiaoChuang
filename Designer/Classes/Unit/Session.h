//
//  Session.h
//  Pet21Show
//
//  Created by zeng on 12-8-13.
//  Copyright (c) 2012年 zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject

+(id)getSession:(NSString *)keyName;
+(void)setSession:(NSString *)keyName value:(id)value;
+(void)clearSession;

@end
