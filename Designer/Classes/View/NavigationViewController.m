//
//  NavigationViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-19.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//


static const CGFloat kAnimationDuration = 0.5f;
static const CGFloat kAnimationDelay = 0.0f;
static const CGFloat kMaxBlackMaskAlpha = 0.8f;




#import "NavigationViewController.h"



@interface NavigationViewController ()

@end

@implementation NavigationViewController


#pragma mark - Get the size of view in the main screen
- (CGRect) viewBoundsWithOrientation:(UIInterfaceOrientation)orientation{
	CGRect bounds = [UIScreen mainScreen].bounds;
    if([[UIApplication sharedApplication]isStatusBarHidden]){
        return bounds;
    } else if(UIInterfaceOrientationIsLandscape(orientation)){
		CGFloat width = bounds.size.width;
		bounds.size.width = bounds.size.height;
        if (iOS7)  {
            bounds.size.height = width - 20;
        }else {
            bounds.size.height = width;
        }
        return bounds;
	}else{
        if (iOS7)  {
            bounds.size.height-=20;
        }
        return bounds;
    }
}


- (void)pushViewController:(NavigationViewController *)rootController :(NavigationViewController *)navController
{

    
    navController.view.frame = CGRectMake(320, 0, screen_Width, screen_Height);
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];

    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        rootController.view.frame = CGRectMake(-100, 0, screen_Width, screen_Height);
        navController.view.frame = CGRectMake(0, 0, screen_Width, screen_Height);
    }];
    
}

- (void)popViewController:(NavigationViewController *)rootController :(NavigationViewController *)navController
{
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        rootController.view.frame = CGRectMake(0, 0, screen_Width, screen_Height);
        navController.view.frame = CGRectMake(320, 0, screen_Width, screen_Height);
    }];
    
    [navController.view removeFromSuperview];
    [navController removeFromParentViewController];
    
}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    [self.view addSubview:viewController.view];
    
    [self addChildViewController:viewController];
    
    [self.view bringSubviewToFront:_navigationBarView];

}

- (void)popViewControllerAnimat:(BOOL)animated
{
    UIViewController *vc = (UIViewController *) [self.viewControllers lastObject];
    
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    
}



- (void)setNavtionBarBackground
{
    
    NSString *navImageName = [NSString string];
    if (iOS7) {
        navImageName = @"nav-bg-7";
    }else {
        navImageName = @"nav-bg";
    }
    UIImage *img = [UIImage imageNamed:navImageName] ;

    _navigationBarView.backgroundColor = [UIColor colorWithPatternImage:img];

}

- (void)addNavitionBarView
{
    _navigationBarView = [[UIView alloc] init];
    if (iOS7) {
        _navigationBarView.frame = CGRectMake(0, 0, 640, 64);
    }
    else {
        _navigationBarView.frame = CGRectMake(0, 0, 640, 44);
    }
    
    
    _leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:_leftBarButton];
    
    
    _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationBarView addSubview:_rightBarButton];
    
    
    [self.view addSubview:_navigationBarView];

}


- (id) initWithRootViewController:(UIViewController*)rootViewController
{
    if (self = [super init]) {
        [self addNavitionBarView];
        [self setNavtionBarBackground];
        
    }
    return self;
}


- (void)setRootViewViewController:(UIViewController *)viewController
{
    
    self.viewControllers = [NSMutableArray arrayWithObject:viewController];


    
    
    UIViewController *rootViewController = [self.viewControllers objectAtIndex:0];
    
    [self addChildViewController:rootViewController];
    [self.view addSubview:rootViewController.view];
    
    _leftBarButton = rootViewController.navigationViewController.leftBarButton;
    

    [self.view bringSubviewToFront:_navigationBarView];
}


- (void)loadView
{
    [super loadView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



@implementation UIViewController (NavigationControllerItem)

@dynamic navigationViewController;

- (NavigationViewController *)navigationViewController
{
    
    if([self.parentViewController isKindOfClass:[NavigationViewController class]]){
        return (NavigationViewController*)self.parentViewController;
    }
    else if([self.parentViewController isKindOfClass:[UINavigationController class]] &&
            [self.parentViewController.parentViewController isKindOfClass:[NavigationViewController class]]){
        return (NavigationViewController*)[self.parentViewController parentViewController];
    }
    else{
        return nil;
    }
    
}



@end


