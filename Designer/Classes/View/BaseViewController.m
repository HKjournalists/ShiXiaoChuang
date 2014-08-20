//
//  BaseViewController.m
//  Dyrs
//
//  Created by mbp  on 13-8-22.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
}
@end

@implementation BaseViewController


- (void)back:(UIButton *)button
{
    
    
    


    [UIView animateWithDuration:KMiddleDuration animations:^{
        self.view.alpha  = 0;
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
        }
    }];

    

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight|| toInterfaceOrientation == UIDeviceOrientationLandscapeLeft);
}





- (void)addMemu
{
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}



-(UIStatusBarStyle)preferredStatusBarStyle{
    if (iOS7) {
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.frame = CGRectMake(0, 0, 1024, 20);
        statuebar_gb_ImageView.image = [[ImageView share] createSolidColorImageWithColor:[UIColor blackColor] andSize:statuebar_gb_ImageView.frame.size];

        [self.view addSubview:statuebar_gb_ImageView];
    }
    return UIStatusBarStyleLightContent;
}



- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"实小创-allbg"]];
    self.view.frame = CGRectMake(0, 0, 1024, 768);
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    _baseView.clipsToBounds = YES;
    self.baseView .backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"实小创-allbg"]];
    [self.view addSubview:_baseView];

}

- (void)addLogo
{
    [[ImageView share] addToView:self.baseView imagePathName:@"logo" rect:RectMake2x(74, 66, 389, 102)];

}


- (void)addBackView
{
    [[Button share] addToView:self.view addTarget:self rect:CGRectMake(0  , 713, 110/2, 110/2) tag:Action_Back action:@selector(back:) imagePath:@"按钮-返回"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addMemu];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
