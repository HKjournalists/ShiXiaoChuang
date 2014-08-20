//
//  ZHTmpeViewController.h
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-28.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"

@interface ZHTmpeViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    float currentY;
    NSString *dept;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tb;
@property (weak, nonatomic) IBOutlet UISwitch *warnSwitch;

@property (weak, nonatomic) IBOutlet UILabel *sendType;



- (IBAction)submitTable:(id)sender;
- (IBAction)openCamer:(id)sender;


- (IBAction)sendTypeSender:(id)sender;


@end
