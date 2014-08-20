//
//  ZHFinesViewController.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-25.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHFinesViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XMLReader.h"
#import "ZHFineListViewController.h"
#import "WKKViewController.h"

@interface ZHFinesViewController ()

@end

@implementation ZHFinesViewController

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
    NSMutableDictionary *dict1  = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dict in self.dataMArray) {
        NSString *type = dict[@"Type1"][@"text"];
        
        [dict1 setValue:dict forKey:type];
    }
    
    a1 = dict1.allValues;
    
    [self.pickerView reloadComponent:0];

    a2 = nil;
    [self.pickerView reloadComponent:1];
    a3 = nil;
    [self.pickerView reloadComponent:2];

}

- (void)array2:(NSString *)string
{
    //    type2
    NSMutableDictionary *dict2  = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dict in self.dataMArray) {
        
        if ([dict[@"Type1"][@"text"] isEqualToString:string]) {
            NSString *type = dict[@"Type2"][@"text"];
            [dict2 setValue:dict forKey:type];
        }

    }
    a2 = dict2.allValues;
    [self.pickerView reloadComponent:1];

    [self array3:a2[0][@"Type2"][@"text"] ];

    

}

- (void)array3:(NSString *)string
{
    //    type3
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dict in self.dataMArray) {
        if ([dict[@"Type2"][@"text"] isEqualToString:string]) {
            NSString *type = dict[@"Type3"][@"text"];
            [dict3 setValue:dict forKey:type];
        }
        

    }
    a3 = dict3.allValues;
    
    
    [self.pickerView reloadComponent:2];

}

#pragma mark - net work 
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (IBAction)takePhoto:(id)sender {
    

    
    [self submitFines:nil];
    
}

- (IBAction)submitFines:(id)sender {
    
    [_textView resignFirstResponder];

    if ([_textView.text isEqualToString:@""]) {
        
        [[Message share] messageAlert:@"内容不能为空，请填写内容"];
        return;
    
    }
    
    if (current_Dict.count == 0) {

        [[Message share] messageAlert:@"请选择罚款原因！"];

        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"拍照前，需要先提交罚款数据， 请稍等。。。" maskType:SVProgressHUDMaskTypeGradient];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
//    1875
    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/AddFine"];
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/AddFine", KHomeUrl];

    NSString *string = current_Dict[@"Money"][@"text"];
    float money = [string floatValue];
    
    NSString *reson = [NSString stringWithFormat:@"%@;%@", _textView.text, _ttextView.text];

    
    
    NSDictionary *parameters = @{@"orderId": self.dataMDict[@"Id"][@"text"],
                                 @"monitorId": SharedAppUser.ID ,
                                 @"fineReason": current_Dict[@"Id"][@"text"],
                                 @"money": [NSNumber numberWithFloat: money],
                                 @"monitorName": SharedAppUser.account,
                                 @"remark": reson
                                 };
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *parseError = nil;
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        
        NSString *ms = [NSString stringWithFormat:@"<str>%@</str>", s];
        
        NSDictionary  *dict = [XMLReader dictionaryForXMLString:ms error:&parseError];
        
        
        dict = dict[@"str"];

        
        if (  ! [dict[@"state"][@"text"] isEqualToString:@"200"] ) {
            [SVProgressHUD dismiss];
            
            
            
            
            
            
            [[Message share] messageAlert:[NSString stringWithFormat:@"%@", s]];
            
            return ;
        }
        else {
            _textView.text = @"";
            _ttextView.text = @"";
            
            WKKViewController *kvc = [[WKKViewController alloc] initWithNibName:@"WKKViewController" bundle:nil];
            kvc.type =  1;
            kvc.orderID = self.dataMDict[@"Id"][@"text"];
            kvc.itemId = dict[@"id"][@"text"];
            
            [self.view addSubview:kvc.view];
            [self addChildViewController:kvc];
            

            [SVProgressHUD showWithStatus:@"提交罚款信息成功, 正在打开照相机，相机打开后，就可以对该记录进行拍照记录了。" maskType:SVProgressHUDMaskTypeGradient];
            

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
    
    
    
    
    
    ZHFineListViewController *lvc = [[ZHFineListViewController alloc] init];
    //    lvc.pactNumer =  self.dataMDict[@"PactNumer"][@"text"];
    lvc.dataMDict = self.dataMDict;
    
    [self.view addSubview:lvc.view];
    [self addChildViewController:lvc];
    
}

-(void)formatData:(NSArray *)array
{
    
 
    a1 = [[NSMutableArray alloc] init];
    a2 = [[NSMutableArray alloc] init];
    a3 = [[NSMutableArray alloc] init];

    
    NSMutableDictionary *dict1  = [NSMutableDictionary dictionary];

    for (NSDictionary *dict in self.dataMArray) {
        NSString *type = dict[@"Type1"][@"text"];
        
        [dict1 setValue:type forKey:type];
    }
    
    a1 = [NSMutableArray arrayWithArray: dict1.allValues];

    
    
    

    for (NSString *string in a1) {
        
        
        NSMutableDictionary *dict1  = [NSMutableDictionary dictionary];

        for (NSMutableDictionary *dict in self.dataMArray) {
            if ([dict[@"Type1"][@"text"] isEqualToString:string]) {
                NSString *type = dict[@"Type2"][@"text"];

                [dict1 setValue:type forKey:type];
        
            }
        }
        
        for (NSString *s in dict1.allValues) {

            [a2 addObject:@{string: s}];
        }


    }


    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (NSString *s in a1) {
        
        for (NSDictionary *d in a2) {
            
            if (d[s]) {
                [a addObject:d[s]];
            }

        }
        
    }
    
    
    for (NSString *string in a) {
        
        
        NSMutableDictionary *dict1  = [NSMutableDictionary dictionary];
        
        for (NSMutableDictionary *dict in self.dataMArray) {
            if ([dict[@"Type2"][@"text"] isEqualToString:string]) {
                NSString *type = dict[@"Type3"][@"text"];
                
                [dict1 setValue:type forKey:type];
                
            }
        }
        
        for (NSString *s in dict1.allValues) {
            
            [a3 addObject:@{string: s}];
        }
        
        
    }

    
    pv.dataArray = [[NSMutableArray alloc] initWithArray: @[a1, a2, a3]];
    
}

- (void)GetFineResaons
{
    [self.dataMArray removeAllObjects];
     
    [SVProgressHUD showWithStatus:@"正在获取罚款原因数据..." maskType:SVProgressHUDMaskTypeGradient];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/GetFineResaons"];
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/GetFineResaons", KHomeUrl];

    NSDictionary *parameters = @{@"pactnumber": self.dataMDict[@"PactNumer"][@"text"]};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSError *parseError = nil;
        
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSDictionary *dict = [XMLReader dictionaryForXMLString:s error:&parseError];
        
        if (dict == nil) {
            [SVProgressHUD dismiss];
            
            [[Message share] messageAlert:[NSString stringWithFormat:@"%@", s]];
            
            return ;
        }
        else {
            
            
            [SVProgressHUD dismiss];

            
            self.dataMArray = [[NSMutableArray alloc] initWithArray: dict[@"ArrayOfFineReason"][@"FineReason"] ];
            
//            [self array1];
//            pv.dataArray = self.dataMArray;
            [self formatData:self.dataMArray];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    
    _ttextView.layer.borderWidth = 1;
    _ttextView.layer.borderColor = [[UIColor blackColor] CGColor];
    _ttextView.layer.cornerRadius = 6;
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"实小创-allbg"]];

    [[Button share] addToView:self.view addTarget:self rect:RectMake2x(1942,  61, 71, 63) tag:1 action:@selector(back:) imagePath:@"按钮-返回1"];

    self.baseView.alpha = 0;
    
    
//    self.pickerView
    pv = [[ZHPickerView alloc] init];
    pv.frame = self.pickerView.frame;

    pv.cloumnCount = 3;
    pv.delegate = self;

    [self.view addSubview:pv];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self GetFineResaons];
    
    if ( SharedAppUser.isSignalIn == YES ) {
        self.submitButton.alpha = 1;
    }
    else {
        self.submitButton.alpha = 0;
    }

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
        tView.text =  a1[row][@"Type1"][@"text"];
    }
    else if (component == 1)
    {
        tView.text =  a2[row][@"Type2"][@"text"];
    }
    else if (component == 2)
    {
        tView.text =  a3[row][@"Type3"][@"text"];
    }
    
    return tView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (component == 0)
    {
//        self.textView.text = [NSString stringWithFormat:@"[%@]", a1[row][@"Type1"][@"text"]];
        
        [self array2:a1[row][@"Type1"][@"text"] ];
    }
    else if (component == 1)
    {
//        self.textView.text = [NSString stringWithFormat:@"%@[%@]", self.textView.text , a2[row][@"Type2"][@"text"]];
        
        [self array3:a2[row][@"Type2"][@"text"]];
    
    }
    else if (component == 2) {
        
        current_Dict = a3[row];
        self.textView.text = [NSString stringWithFormat:@"[%@][%@][%@][罚款：%@]",  a3[row][@"Type1"][@"text"], a3[row][@"Type2"][@"text"], a3[row][@"Type3"][@"text"],
                              a3[row][@"Money"][@"text"]];

    }
    
}



#pragma mark -

- (void)selectResult:(NSString *)string currentString:(NSString *)currentString
{
    
    

    for (NSDictionary *d in self.dataMArray) {
        
        if ([d[@"Type3"][@"text"] isEqualToString:currentString]) {
            current_Dict = d;
        }
    }
    
    _textView.text = [NSString stringWithFormat:@"%@%@", string, current_Dict[@"Money"][@"text"]];
    
    
}

#pragma mark - 

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.view.frame  =CGRectMake(0, -350, 1024, 768);

    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    self.view.frame  =CGRectMake(0, 0, 1024, 768);

    return YES;
}

@end
