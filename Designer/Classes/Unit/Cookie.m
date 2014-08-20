//
//  Cookie.m
//  M32
//
//  Created by i-Bejoy on 13-12-6.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "Cookie.h"

@implementation Cookie


+ (id)getCookie:(NSString *)keyName
{
	if(![keyName isEqualToString:@""] && keyName != nil)
	{

        NSMutableDictionary *array = (NSMutableDictionary *)[KNSUserDefaults objectForKey:keyName];
        
        if (array == nil) {
            return nil;
        }
		return array;
	}
	
	return @"";
}




+ (void)setCookie:(NSString *)keyName value:(id)value;
{
    
    [KNSUserDefaults setObject:value forKey:keyName];

    [KNSUserDefaults synchronize];
    
}






@end
