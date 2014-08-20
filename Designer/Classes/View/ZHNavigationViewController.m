//
//  ZHNavigationViewController.m
//  testNavigation
//
//  Created by i-Bejoy on 13-11-23.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ZHNavigationViewController.h"




static const CGFloat kAnimationDuration = 0.5f;
static const CGFloat kAnimationDelay = 0.0f;
static const CGFloat kMaxBlackMaskAlpha = 0.8f;



@interface ZHNavigationViewController ()

@end

@implementation ZHNavigationViewController



#pragma mark - ChildViewController
- (UIViewController *)currentViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count]>0) {
        result = [self.viewControllers lastObject];
    }
    return result;
}

#pragma mark - ParentViewController
- (UIViewController *)previousViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count]>1) {
        result = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }
    return result;
}







- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#define screen_Width [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

- (id) initWithRootViewController:(UIViewController*)rootViewController {
    if (self = [super init]) {
        self.viewControllers = [NSMutableArray arrayWithObject:rootViewController];
        
    }
    return self;
}

- (void) pushViewController:(UIViewController *)viewController
{
    viewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
    viewController.view.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:0 animations:^{
        
        
        
        
        if ( iOS7) {
            [self currentViewController].view.frame = CGRectMake(-100, 0, screen_Width, screenHeight);
        }
        else {
            [self currentViewController].view.frame = CGRectMake(-100, 20, screen_Width, screenHeight);
        }
        
        viewController.view.frame = CGRectMake(0, 0, screen_Width, screenHeight);
        
        viewController.view.frame = self.view.bounds;
        
        
    }   completion:^(BOOL finished) {
        if (finished) {
            [self.viewControllers addObject:viewController];

        }
    }];
    
}


- (void) modelViewController:(UIViewController *)viewController
{
    viewController.view.frame = CGRectMake(0, screenHeight, screen_Width, screenHeight);
    viewController.view.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:0 animations:^{
        
        
        
        viewController.view.frame = CGRectMake(0, 0, screen_Width, screenHeight);
        
        viewController.view.frame = self.view.bounds;
        
        
    }   completion:^(BOOL finished) {
        if (finished) {
            [self.viewControllers addObject:viewController];
            
        }
    }];

}

- (void) popModelViewController
{
    UIViewController *currentVC = [self currentViewController];
    UIViewController *previousVC = [self previousViewController];
    [previousVC viewWillAppear:NO];
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:0 animations:^{
        
        previousVC.view.frame = CGRectMake(0, 0, screen_Width, screenHeight);
        currentVC.view.frame = CGRectMake(0, screenHeight, screen_Width, screenHeight);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [currentVC.view removeFromSuperview];
            [currentVC willMoveToParentViewController:nil];
            [self.view bringSubviewToFront:[self previousViewController].view];
            [currentVC removeFromParentViewController];
            [currentVC didMoveToParentViewController:nil];
            [self.viewControllers removeObject:currentVC];
            [previousVC viewDidAppear:NO];
            
            
            
        }
    }];
}


- (void) popViewController
{
    if (self.viewControllers.count < 2) {
        return;
    }
    

    
    UIViewController *currentVC = [self currentViewController];
    UIViewController *previousVC = [self previousViewController];
    [previousVC viewWillAppear:NO];
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:0 animations:^{

        if ( iOS7) {
            previousVC.view.frame = CGRectMake(0, 0, screen_Width, screenHeight);
        }
        else {
            previousVC.view.frame = CGRectMake(0, 20, screen_Width, screenHeight);
        }

        
        currentVC.view.frame = CGRectMake(320, 0, screen_Width, screenHeight);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [currentVC.view removeFromSuperview];
            [currentVC willMoveToParentViewController:nil];
            [self.view bringSubviewToFront:[self previousViewController].view];
            [currentVC removeFromParentViewController];
            [currentVC didMoveToParentViewController:nil];
            [self.viewControllers removeObject:currentVC];
            [previousVC viewDidAppear:NO];
            
            

        }
    }];

    

}



- (void) loadView {
    
    
    [super loadView];
    
    
    UIViewController *rootViewController = [self.viewControllers objectAtIndex:0];
    [self addChildViewController:rootViewController];
    
    UIView * rootView = rootViewController.view;
    [self.view addSubview:rootView];

    
    
    

}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





@implementation UIViewController (ZHUser)
@dynamic userDict;



- (NSDictionary *)userDict
{
    return self.userDict;
}

@end

#pragma mark - UIViewController Category
//For Global Access of flipViewController
@implementation UIViewController (ZHNavigationViewController)
@dynamic zhNavigationController;

- (ZHNavigationViewController *)zhNavigationController
{
    
    if([self.parentViewController isKindOfClass:[ZHNavigationViewController class]]){
        return (ZHNavigationViewController*)self.parentViewController;
    }
    else if([self.parentViewController isKindOfClass:[UINavigationController class]] &&
            [self.parentViewController.parentViewController isKindOfClass:[ZHNavigationViewController class]]){
        return (ZHNavigationViewController*)[self.parentViewController parentViewController];
    }
    else{
        return nil;
    }
    
}


@end


