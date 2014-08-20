//
//  NavigationViewController.h
//  M32
//
//  Created by i-Bejoy on 13-11-19.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"

@interface NavigationViewController : BaseViewController


@property(nonatomic,retain) UIButton *leftBarButton;
@property(nonatomic,retain) UIButton *rightBarButton;
@property(nonatomic,retain) UIView *navigationBarView;

@property(nonatomic,copy) NSMutableArray *viewControllers;





- (id) initWithRootViewController:(UIViewController *)rootViewController;
- (void)setRootViewViewController:(UIViewController *)rootViewController;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewControllerAnimat:(BOOL)animated;






@end


@interface UIViewController (NavigationControllerItem)

@property(nonatomic,readonly,retain) NavigationViewController *navigationViewController;

@end