//
//  ZHBaseMaterialsViewController.h
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-24.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"

@interface ZHDelayListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *tb;

    NSInteger currentIndex;
    UIButton *currentButton;
    
    float currentOffset;
}

@property(nonatomic, strong) NSString *pactNumer;

@end
