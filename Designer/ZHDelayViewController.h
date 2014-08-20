//
//  ZHFinesViewController.h
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-25.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"

@interface ZHDelayViewController : BaseViewController<UIPickerViewDataSource, UIPickerViewDelegate, ZHPickerViewDelegate>
{
    NSArray *a1;
    NSArray *a2;
    NSArray *a3;
    NSArray *a4;
    
    NSDictionary *current_Dict;
    
    
    
    ZHPickerView *pv;
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UITextField *daysTextField;

@property (weak, nonatomic) IBOutlet UISwitch *alertSwitch;

- (IBAction)submitFines:(id)sender;
- (IBAction)openHistory:(id)sender;
- (IBAction)take_photo:(id)sender;

@end
