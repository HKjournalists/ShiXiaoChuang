//
//  Image.h
//  ShiXiaoChuang
//
//  Created by bejoy on 14-5-4.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Image : UIImage



+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;


+ (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;


+ (UIImage *)imageNamed:(NSString *)name;      // load from main bundle



@end
