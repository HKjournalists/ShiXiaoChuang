//
//  ImageView.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ImageView.h"
#import "CommonMethod.h"
#import "Unit.h"


static ImageView *imageView;


@implementation ImageView

+ (id)share
{
    if (imageView) {
        return imageView;
    }
    imageView = [[ImageView alloc] init];
    return imageView;
}

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (UIImageView *)addToView:(UIView *)view imagePathName:(NSString *)imagePathName pathNameType:(NSString *)pathNameType rect:(CGRect)frame
{
    
    NSString  *path1 = [MAINBUNDLE pathForResource:imagePathName ofType:pathNameType];
    
    UIImage* img =  [[UIImage alloc] initWithContentsOfFile:path1];
    
    
    if (img == nil) {
        img = [UIImage imageNamed:imagePathName];
    }
    UIImageView  *imageView= [[UIImageView alloc] initWithFrame:frame];
    imageView.image  = img;
    [view addSubview:imageView];
    
    return  imageView;
}

- (UIImageView *)addToView:(UIView *)view imagePathNamePNG:(NSString *)imagePathName rect:(CGRect)frame
{
    return [self addToView:view imagePathName:imagePathName pathNameType:@"png" rect:frame];
    
}

- (UIImageView *)addToView:(UIView *)view imagePathNameJPG:(NSString *)imagePathName rect:(CGRect)frame
{
    return [self addToView:view imagePathName:imagePathName pathNameType:@"jpg" rect:frame];
}

- (UIImageView *)addToView:(UIView *)view imagePathName:(NSString *)imagePathName rect:(CGRect)frame
{
    UIImage* img =  [UIImage imageNamed:imagePathName];
    
    UIImageView  *imageView= [[UIImageView alloc] initWithFrame:frame];
    imageView.image  = img;
    [view addSubview:imageView];
    
    return  imageView;
}




-(UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size{
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
