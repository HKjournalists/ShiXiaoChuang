//
//  Session.m
//  Pet21Show
//
//  Created by zeng on 12-8-13.
//  Copyright (c) 2012年 zeng. All rights reserved.
//

#import "Session.h"

@implementation Session

static NSMutableDictionary *sessionDictionary;

+ (id)getSession:(NSString *)keyName
{
	if(![keyName isEqualToString:@""] && keyName != nil)
	{
		return [sessionDictionary objectForKey:keyName];
	}
	
	return @"";
}

+ (void)setSession:(NSString *)keyName value:(id)value;
{
	if(sessionDictionary)
	{}
	else
	{
        
		sessionDictionary = [[NSMutableDictionary alloc] init];
	}
	[sessionDictionary setObject:value forKey:keyName];
	
}

+ (void)clearSession
{
	if(sessionDictionary)
	{
		[sessionDictionary removeAllObjects];
	}
}

@end
