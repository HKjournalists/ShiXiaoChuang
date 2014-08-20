//
//  BejoyViewController.m
//  Designer
//
//  Created by bejoy on 14-3-4.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "BejoyViewController.h"

@interface BejoyViewController ()
{
    UIImageView *adImageView;
}
@end

@implementation BejoyViewController


//- (void)back:(UIButton *)button
//{
//    
//    
//    [UIView animateWithDuration:KMiddleDuration animations:^{
//        self.view.alpha  = 0;
//    }];
//    
//    
//    
//}

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AD-bejoy-0"]];
    
    adImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AD-bejoy-1"]];
    adImageView.frame = CGRectMake(1024, 0, 1024, 768);

    [self.view addSubview:adImageView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.menuView.backgroundColor = [UIColor clearColor];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [UIView animateWithDuration:KMiddleDuration animations:^{
        adImageView.frame = self.view.frame;
        
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
