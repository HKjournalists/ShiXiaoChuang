//
//  ImageView.h
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMethod.h"

@interface ImageView : NSObject


+ (id)share;



- (UIImageView *)addToView:(UIView *)view imagePathNamePNG:(NSString *)imagePathName rect:(CGRect)frame;
- (UIImageView *)addToView:(UIView *)view imagePathNameJPG:(NSString *)imagePathName rect:(CGRect)frame;
- (UIImageView *)addToView:(UIView *)view imagePathName:(NSString *)imagePathName rect:(CGRect)frame;

- (UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size;


@end
