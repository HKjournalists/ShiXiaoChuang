//
//  ZHFinesViewController.h
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-25.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"

@interface ZHFinesViewController : BaseViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, ZHPickerViewDelegate>
{
    NSMutableArray *a1;
    NSMutableArray *a2;
    NSMutableArray *a3;
    NSMutableArray *a4;

    
    NSDictionary *current_Dict;
    
    
    ZHPickerView *pv;
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *ttextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;



- (IBAction)takePhoto:(id)sender;

- (IBAction)submitFines:(id)sender;
- (IBAction)openHistory:(id)sender;

@end
