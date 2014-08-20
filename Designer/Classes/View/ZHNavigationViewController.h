//
//  ZHNavigationViewController.h
//  testNavigation
//
//  Created by i-Bejoy on 13-11-23.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHNavigationViewController : UIViewController





@property(nonatomic, retain) NSMutableArray *viewControllers;

- (id) initWithRootViewController:(UIViewController*)rootViewController;

- (void) pushViewController:(UIViewController *)viewController;
- (void) popViewController;

- (void) modelViewController:(UIViewController *)viewController;
- (void) popModelViewController;



@end



@interface UIViewController (ZHUser)

@property (nonatomic, retain) NSDictionary *userDict;
@end


@interface UIViewController (ZHNavigationViewController)

@property (nonatomic, retain) ZHNavigationViewController *zhNavigationController;
@end