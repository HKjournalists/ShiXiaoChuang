//
//  ZHChangeOrderListViewController.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-17.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHChangeOrderListViewController.h"

@interface ZHChangeOrderListViewController ()

@end

@implementation ZHChangeOrderListViewController

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

    
    
    UIButton *b = [[Button share] addToView:self.view addTarget:self rect:CGRectMake(0, 768-150, 350/2, 300) tag:1 action:@selector(back:)];
    b.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
