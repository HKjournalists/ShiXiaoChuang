//
//  ActivityIndicatorView.h
//  Dyrs
//
//  Created by mbp  on 13-8-30.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicatorView : UIView

@property(nonatomic, retain) UIActivityIndicatorView *aiv;


+ (id)share;


- (void)show;

- (void)hidden;


@end
