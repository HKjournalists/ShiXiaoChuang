//
//  ZHAppDelegate.h
//  Dyrs
//
//  Created by mbp  on 13-8-12.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import  "BMapKit.h"


@class ZHViewController;

@interface ZHAppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>

@property (nonatomic, strong) User *user;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ZHViewController *viewController;
@property (strong, nonatomic) UINavigationController *masterNavigationController;
@end
