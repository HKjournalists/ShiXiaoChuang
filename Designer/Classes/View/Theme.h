//
//  Theme.h
//  Designer
//
//  Created by bejoy on 14-3-24.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject

+ (id)share;

- (NSString *)getColorForKey:(NSString *)keyString;


- (UIColor *)giveColorfromStringRGB:(NSString *)colorname;

- (UIColor *)giveColorfromStringColor:(NSString *)colorname;
@end
