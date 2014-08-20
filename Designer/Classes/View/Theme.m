//
//  Theme.m
//  Designer
//
//  Created by bejoy on 14-3-24.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "Theme.h"


static Theme *theme;

@implementation Theme


NSDictionary *themeDict;

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}




+ (id)share
{
    if (theme) {
        return theme;
    }
    theme = [[Theme alloc] init];

    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
    
    themeDict = [NSDictionary dictionaryWithContentsOfFile:pathStr];
    return theme;
}



- (UIColor *)giveColorfromStringColor:(NSString *)colorStr
{
    
    NSString *colorname = [themeDict objectForKey:colorStr];

    
    SEL labelColor = NSSelectorFromString(colorname);
    UIColor *color = [UIColor performSelector:labelColor];
    return color;
}

- (UIColor *)giveColorfromStringRGB:(NSString *)colorname
{
    
    NSArray *parts = [colorname componentsSeparatedByString:@" "];
    
    UIColor *colorFromString = [UIColor colorWithRed:[parts[0] floatValue] green:[parts[1] floatValue] blue:[parts[2] floatValue] alpha:[parts[3] floatValue]];
    
    
    
    return colorFromString;
}




- (NSString *)getColorForKey:(NSString *)keyString
{
    
    NSString *string = [themeDict objectForKey:keyString];
    
    return string;
}

- (NSString *)getColorForRGB:(NSString *)keyString
{
    
    NSString *string = [themeDict objectForKey:keyString];
    
    return string;
}



@end
