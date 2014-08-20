//
//  ZHFinesViewController.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-25.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHDelayViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XMLReader.h"

#import "ZHDelayListViewController.h"
#import "WKKViewController.h"


@interface ZHDelayViewController ()

@end

@implementation ZHDelayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;


}

- (void)array1
{
    
//    客户原因
//    设计原因
//    工程原因
//    材料原因
//    其他原因
    a1 = @[ @"客户原因", @"设计原因", @"工程原因", @"材料原因", @"其他原因"];
    a2 = nil;
    a3 = nil;
    [self.pickerView reloadComponent:0];
    [self.pickerView reloadComponent:1];
    [self.pickerView reloadComponent:2];


}

- (void)array2:(int)row
{
//    水路施工
//    电路施工
//    瓦工施工
//    木工施工
//    油工施工
//    其他
    

    NSArray  *a = @[@[@"水路施工",@"电路施工",@"瓦工施工",@"木工施工",@"油工施工",@"其他",], @[@"厨房", @"卫生间", @"卧室", @"功能房", @"餐厅", @"客厅", @"阳台"]];
    if (row ==2) {
        a2 = a[0];
    }
    else if (row == 3){
        a2 = a[1];
    }
    else {
        a2 = nil;
    }
    a3 = nil;
    [self.pickerView reloadComponent:1];
    [self.pickerView reloadComponent:2];

}


- (void)array3:(int)row
{
    NSArray *array = @[@[@"瓷砖",@"铝扣板吊顶",@"整体橱柜",@"木门及五金",@"窗套、哑口及护角",@"烟机灶具",@"水槽龙头",@"其它"],@[@"瓷砖",@"铝扣板吊顶",@"浴霸",@"木门及五金",@"窗套、哑口及护角",@"洁具",@"卫浴五金",@"其它"],@[@"瓷砖",@"木门及五金",@"窗套、哑口及护角",@"地板",@"涂料",@"其他"],@[@"瓷砖",@"木门及五金",@"窗套、哑口及护角",@"地板",@"涂料",@"其他"],@[@"瓷砖",@"木门及五金",@"窗套、哑口及护角",@"地板",@"涂料",@"其它"],@[@"瓷砖",@"木门及五金",@"窗套、哑口及护角",@"地板",@"涂料",@"其他"],@[@"瓷砖",@"铝扣板吊顶",@"木门及五金",@"窗套、哑口及护角",@"地板",@"涂料",@"其他"]];
    a3 = array[row];
    [self.pickerView reloadComponent:2];
}

#pragma mark -

- (void)selectResult:(NSString *)string currentString:(NSString *)currentString
{
    
    

    
    _textView.text = string;
    
    
}




#pragma mark - net work 

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


- (IBAction)submitFines:(id)sender {
    [_textView resignFirstResponder];

    
    if ([_textView.text isEqualToString:@""] ) {
        
        [[Message share] messageAlert:@"内容不能为空，请填写内容"];
        return;
        
    }

    
    if ( ! [_daysTextField.text isEqualToString:@""]) {
        if (  [ self isPureInt:_daysTextField.text]   ) {
            
            if ( [_daysTextField.text intValue] < 0  ) {
                [[Message share] messageAlert:@"延期天数只能填写正整数"];
                return;
            }
            
        }
        else {
            [[Message share] messageAlert:@"延期天数只能填写正整数"];
            return;
        }
    }
    else {
        [[Message share] messageAlert:@"延期天数不能为空，请务必填写！"];
        return;
    }
    
    [self.dataMArray removeAllObjects];
    
    [SVProgressHUD showWithStatus:@"提交延期数据..." maskType:SVProgressHUDMaskTypeGradient];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
//    1875
    
//    报警
    
    NSString *alertStr = [NSString stringWithFormat:@"0"];
    if (_alertSwitch.on ) {
        alertStr = @"1";
    }
    
    NSString *reson = [NSString stringWithFormat:@"%@;%@", _textView.text, _contentTextView.text];
    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/addDelay"];
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/addDelay", KHomeUrl];

    NSDictionary *parameters = @{@"orderId": self.dataMDict[@"Id"][@"text"],
                                 @"reason": reson,
                                 @"delayDays": [NSNumber numberWithInt:[_daysTextField.text intValue]]
                                
                                 };
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *parseError = nil;
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSString *ms = [NSString stringWithFormat:@"<str>%@</str>", s];
        
        NSDictionary  *dict = [XMLReader dictionaryForXMLString:ms error:&parseError];
        

        dict = dict[@"str"];
        
        if ( ! [dict[@"state"][@"text"] isEqualToString:@"200"] ) {
            [SVProgressHUD dismiss];
            
            [[Message share] messageAlert:[NSString stringWithFormat:@"提交失败，请检查后再试！"]];
            
            return ;
        }
        else {
            
            
//            WKKViewController *kvc = [[WKKViewController alloc] initWithNibName:@"WKKViewController" bundle:nil];
//            kvc.type =  2;
//            kvc.orderID = self.dataMDict[@"Id"][@"text"];
//            kvc.itemId = dict[@"id"][@"text"];
//            
//            [self.view addSubview:kvc.view];
//            [self addChildViewController:kvc];
            
            
            
            [SVProgressHUD showWithStatus:@"提交成功..." maskType:SVProgressHUDMaskTypeGradient];
            
            _textView.text = @"";
            _daysTextField.text = @"";
            _alertSwitch.on = NO;
            _contentTextView.text = @"";
            
            [SVProgressHUD performSelector:@selector(dismiss) withObject:nil afterDelay:2];
            
            
            

            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFinesAndDelay" object:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    
}

- (IBAction)openHistory:(id)sender {
    
    
    
    ZHDelayListViewController *lvc = [[ZHDelayListViewController alloc] init];
//    lvc.pactNumer =  self.dataMDict[@"PactNumer"][@"text"];
    lvc.dataMDict = self.dataMDict;
    
    [self.view addSubview:lvc.view];
    [self addChildViewController:lvc];
    
    
    
}


- (IBAction)take_photo:(id)sender {
    
    
    
    [self submitFines:nil];
    
}


-(void)formatData:(NSArray *)array
{
    
    NSMutableArray *a = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"delay_reson" ofType:@"plist"]];
    
    a1 = [[NSMutableArray alloc] init];
    a2 = [[NSMutableArray alloc] init];
    a3 = [[NSMutableArray alloc] init];
    

    
//    @[@"厨房", @"卫生间", @"卧室", @"功能房", @"餐厅", @"客厅", @"阳台"]
    NSArray *a3_array =
            @[ @{@"厨房":@"瓷砖"}, @{@"厨房":@"铝扣板吊顶"},
               @{@"厨房":@"整体橱柜"}, @{@"厨房":@"木门及五金"}, @{@"厨房":@"窗套、哑口及护角"},
                @{@"厨房":@"烟机灶具"}, @{@"厨房":@"水槽龙头"}, @{@"厨房":@"瓷砖"}, @{@"厨房":@"其它"},
               @{@"卫生间":@"瓷砖"},
               @{@"卫生间":@"铝扣板吊顶"},
               @{@"卫生间":@"浴霸"},
               @{@"卫生间":@"木门及五金"},
               @{@"卫生间":@"窗套、哑口及护角"},
               @{@"卫生间":@"洁具"},
               @{@"卫生间":@"卫浴五金"},
               @{@"卫生间":@"其它"},
               
               @{@"卧室":@"瓷砖"},
               @{@"卧室":@"木门及五金"},
               @{@"卧室":@"窗套、哑口及护角"},
               @{@"卧室":@"地板"},
               @{@"卧室":@"涂料"},
               @{@"卧室":@"其它"},
               
               
               @{@"功能房":@"瓷砖"},
               @{@"功能房":@"木门及五金"},
               @{@"功能房":@"窗套、哑口及护角"},
               @{@"功能房":@"地板"},
               @{@"功能房":@"涂料"},
               @{@"功能房":@"其它"},
               
               @{@"餐厅":@"瓷砖"},
               @{@"餐厅":@"木门及五金"},
               @{@"餐厅":@"窗套、哑口及护角"},
               @{@"餐厅":@"地板"},
               @{@"餐厅":@"涂料"},
               @{@"餐厅":@"其它"},
               
               
               @{@"客厅":@"瓷砖"},
               @{@"客厅":@"木门及五金"},
               @{@"客厅":@"窗套、哑口及护角"},
               @{@"客厅":@"地板"},
               @{@"客厅":@"涂料"},
               @{@"客厅":@"其它"},
               
               @{@"阳台":@"瓷砖"},
               @{@"阳台":@"铝扣板吊顶"},
               @{@"阳台":@"木门及五金"},
               @{@"阳台":@"窗套、哑口及护角"},
               @{@"阳台":@"地板"},
               @{@"阳台":@"涂料"},
               @{@"阳台":@"其它"}
               ];
//    NSArray *a_array =
//          @[
//          @[@"瓷砖",@"铝扣板吊顶",@"整体橱柜",@"木门及五金",@"窗套、哑口及护角",@"烟机灶具",@"水槽龙头",@"其它"],
//          @[@"瓷砖",@"铝扣板吊顶",@"浴霸",@"木门及五金",@"窗套、哑口及护角",@"洁具",@"卫浴五金",@"其它"],
//          @[@"瓷砖",@"木门及五金",@"窗套、哑口及护角",@"地板",@"涂料",@"其他"],
//          @[@"瓷砖",@"木门及五金",@"窗套、哑口及护角",@"地板",@"涂料",@"其他"],
//          @[@"瓷砖",@"木门及五金",@"窗套、哑口及护角",@"地板",@"涂料",@"其它"],
//          @[@"瓷砖",@"木门及五金",@"窗套、哑口及护角",@"地板",@"涂料",@"其他"],
//          @[@"瓷砖",@"铝扣板吊顶",@"木门及五金",@"窗套、哑口及护角",@"地板",@"涂料",@"其他"]
//          ];

    [a addObject:a3_array];

    
    pv.dataArray = a;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self array1];

    _contentTextView.layer.borderWidth = 1;
    _contentTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    _contentTextView.layer.cornerRadius = 6;
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"实小创-allbg"]];

    [[Button share] addToView:self.view addTarget:self rect:RectMake2x(1942,  61, 71, 63) tag:1 action:@selector(back:) imagePath:@"按钮-返回1"];

    self.baseView.alpha = 0;
    
    
    
    
    //    self.pickerView
    pv = [[ZHPickerView alloc] init];
    pv.frame = self.pickerView.frame;
    
    pv.cloumnCount = 3;
    pv.delegate = self;
    
    [self.view addSubview:pv];
    
    
    [self formatData:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
//    [self GetFineResaons];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark dataSouce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return  3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return a1.count;
    }
    else if (component == 1)
    {
        return a2.count;
    }
    else if (component == 2)
    {
        return a3.count;
    }
    return 0;
    
}
#pragma mark delegate


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
    }
    // Fill the label text here
    
    if (component == 0) {
        tView.text =  a1[row];
    }
    else if (component == 1)
    {
        tView.text =  a2[row];
    }
    else if (component == 2)
    {
        tView.text =  a3[row];
    }
    
    return tView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {


    if (self.pickerView.numberOfComponents == component+1) {
        
        NSString *str1 = a1 [[self.pickerView selectedRowInComponent:0]];
        NSString *str2 = a2 [[self.pickerView selectedRowInComponent:1]];
        NSString *str3 = a3 [[self.pickerView selectedRowInComponent:2]];
        
        NSString *str = [NSString stringWithFormat:@"[%@][%@][%@]", str1, str2, str3];
        self.textView.text = str;
        

    }
    else {

        
        if (component == 0) {
            switch (row) {
                case 2:
                    [self array2:row];
                    break;
                case 3:
                    [self array2:row];
                    break;
                default:
                {
                    NSString *str111 = [NSString stringWithFormat:@"[%@]", a1[row]];

                    _textView.text = str111;
                    a2 = nil;
                    a3 = nil;
                    
                    [self.pickerView reloadComponent:1];
                    [self.pickerView reloadComponent:2];
                    
                }
                    break;
            }

        }
        else if (component == 1)
        {

            if  (  [self.pickerView selectedRowInComponent:0] == 2 )
            {
            
                NSString *str1 = a1 [[self.pickerView selectedRowInComponent:0]];
                NSString *str2 = a2 [row];

                NSString *str = [NSString stringWithFormat:@"[%@][%@]", str1, str2];
                self.textView.text = str;

            }
            else if  (  [self.pickerView selectedRowInComponent:0] == 3 )
            {
                [self array3:row];
            }

        }

        

        
        [self.pickerView reloadComponent: component + 1];
    }




    
//    if (component == 0)
//    {
//
//        
//
//        self.textView.text = [NSString stringWithFormat:@"[%@]", a1[row]];
//
//    
//        if (row == 2) {
//           
//            [self array2:0 ];
//        }
//        else  if (row == 3) {
//           
//            [self array2:1 ];
//
//        }
//        
//
//
//
//    }
//    else if (component == 1)
//    {
//
//        if ([a2[row]  isEqualToString:@"*请选择原因"]) {
//         
//            a3 = nil;
//            [self.pickerView reloadComponent:2];
//            
//            return;
//        }
//        else {
//            self.textView.text = [NSString stringWithFormat:@"%@[%@]", self.textView.text , a2[row]];
//
//            [self array3:row];
//        }
//        
//
//
//    }
//    else {
//        
//        if ([a3[row]  isEqualToString:@"*请选择原因"]) {
//            
//        }
//        else {
//            
//            self.textView.text = [NSString stringWithFormat:@"%@[%@]", self.textView.text , a3[row]];
//        }
//    }

    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.view.frame  =CGRectMake(0, -400, 1024, 768);
    
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    self.view.frame  =CGRectMake(0, 0, 1024, 768);
    
    return YES;
}

@end
