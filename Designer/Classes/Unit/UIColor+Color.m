//
//  UIColor+Color.m
//  Designer
//
//  Created by bejoy on 14-3-24.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "UIColor+Color.h"

@implementation UIColor (Color)


+ (UIColor *)giveColorfromStringColor:(NSString *)colorname
{
    SEL labelColor = NSSelectorFromString(colorname);
    UIColor *color = [UIColor performSelector:labelColor];
    return color;
}


@end
