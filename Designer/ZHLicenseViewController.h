//
//  ZHBaseMaterialsViewController.h
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-24.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"


@interface ZHLicenseViewController : BaseViewController<UITableViewDataSource, UITextFieldDelegate,UITableViewDelegate>
{
    UITableView *tb;
    NSInteger currentIndex;

    UIButton *currentButton;
    
    float currentOffsetY;
    
    NSMutableArray *array;
    
    UIButton *footButton;

}
@end
