//
//  UIButton+Utilities.m
//  M32
//
//  Created by i-Bejoy on 13-12-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "UIButton+Utilities.h"

@implementation UIButton(Utilities)


- (void)setIsRemindShow:(bool)isRemindShow
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void)setRemindImage:(UIImage *)image
{
    UIImageView *imgView = [[UIImageView alloc]  init];
    imgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imgView.tag = 100;
    imgView.alpha = 0;
    
    imgView.image = image;
    
    [self addSubview:imgView];
}

- (void)setRemind:(BOOL)isShow
{
    UIImageView *imgView = (UIImageView *)[self viewWithTag:100];
    
    
    if (isShow) {
        imgView.alpha = 1;
    }
    else {
        imgView.alpha = 0;

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
