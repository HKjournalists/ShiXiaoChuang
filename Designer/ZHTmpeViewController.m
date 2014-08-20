//
//  ZHTmpeViewController.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-28.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHTmpeViewController.h"
#import "AFNetworking.h"
#import "XMLReader.h"
#import "LocationManager.h"
#import "SVProgressHUD.h"
#import "WKKViewController.h"

@interface ZHTmpeViewController ()

@end

@implementation ZHTmpeViewController

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
    
    dept = @"wu";
    
    
    self.dataMArray = [[NSMutableArray alloc] init];
    
    
    self.baseView.alpha = 0;
    
    [[Button share] addToView:self.view addTarget:self rect:RectMake2x(1942,  61, 71, 63) tag:1 action:@selector(back:) imagePath:@"按钮-返回1"];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self getTemp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitTable:(id)sender {
    [_textView resignFirstResponder];
    
   
    if ([_textView.text isEqualToString:@""]) {
        
        [[Message share] messageAlert:@"内容不能为空，请填写内容"];
        return;
        
    }
    [SVProgressHUD showWithStatus:@"提交事务数据..." maskType:SVProgressHUDMaskTypeGradient];

    NSString *alertStr = [NSString stringWithFormat:@"0"];
    if (_warnSwitch.on ) {
        alertStr = @"1";
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSDictionary *parameters = @{ @"orderId":  self.dataMDict[@"Id"][@"text"],
                                  @"transactionContent": _textView.text,
                                  @"monitorId": SharedAppUser.ID ,
                                  @"monitorName": SharedAppUser.account,
                                  @"isWarn": alertStr,
                                  @"dept": dept};
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/AddTempAffairs", KHomeUrl];

    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *parseError = nil;
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        NSString  *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        NSString *ms = [NSString stringWithFormat:@"<str>%@</str>", s];

        NSDictionary *dict = [XMLReader dictionaryForXMLString:ms error:&parseError];
        dict = dict[@"str"];
        
        if ( [dict[@"state"][@"text"] isEqualToString:@"200"]  ) {
            
            
            [SVProgressHUD showWithStatus:@"提交成功" maskType:SVProgressHUDMaskTypeGradient];
//            [SVProgressHUD showWithStatus:@"提交成功,正在打开照相机..." maskType:SVProgressHUDMaskTypeGradient];

            

//            WKKViewController *kvc = [[WKKViewController alloc] initWithNibName:@"WKKViewController" bundle:nil];
//            kvc.type =  3;
//            kvc.orderID = self.dataMDict[@"Id"][@"text"];
//            kvc.itemId = dict[@"id"][@"text"];
//            
//            [self.view addSubview:kvc.view];
//            [self addChildViewController:kvc];
            
            
            [self getTemp];
            
            
            _textView.text = @"";
            _warnSwitch.on = NO;
            _sendType.text = @"";
            dept = @"wu";
         }
        else {
            
            [SVProgressHUD dismiss];
            
            [[Message share] messageAlert:@"提交失败，请检查输入的内容后再次尝试。"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
}

- (IBAction)openCamer:(id)sender {
    
//    
//    WKKViewController *kvc = [[WKKViewController alloc] initWithNibName:@"WKKViewController" bundle:nil];
//    kvc.type =  currentProcess + 3;
//    kvc.orderID = self.dataMDict[@"Id"][@"text"];
//    kvc.itemId = indexDict[@"Id"][@"text"];
//    
//    [self.view addSubview:kvc.view];
//    [self addChildViewController:kvc];
    
    [self submitTable:nil];
    
}

- (IBAction)sendTypeSender:(id)sender {
    
    
    UIButton *b = (UIButton *)sender;
    
    NSString *str = @"";
    NSString *strTT = @"";
    switch (b.tag) {
        case 1:
        {
            str = @"yingxiao";
            strTT = @"营销中心";
            break;
        }
        case 2:
        {

            str = @"gongcheng";
            strTT = @"工程部";
            break;
        }
        case 3:
        {
            str = @"dingdan";
            strTT = @"订单中心";
            break;
        }
        case 4:
        {
            str = @"kefu";
            strTT = @"客服部";
            break;
        }
        case 5:
        {
            str = @"wu";
            strTT = @"";
            break;
        }
        default:
            break;
    }
    
    dept = str  ;
    
    _sendType.text = strTT;
    
}


- (void)getTemp
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSDictionary *parameters = @{ @"orderId":  self.dataMDict[@"Id"][@"text"]};
    
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/GetTempAffairs", KHomeUrl];

    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSError *parseError = nil;
        
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSDictionary *dict = [XMLReader dictionaryForXMLString:s error:&parseError];
        
        
        dict = dict[@"Transaction"][@"Transaction"];
        
        if (dict == nil) {
            [SVProgressHUD dismiss];
            
            [[Message share] messageAlert:[NSString stringWithFormat:@"%@", s]];
            
            return ;
        }
        else {
            
            [SVProgressHUD performSelector:@selector(dismiss) withObject:nil afterDelay:2];
            
            if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                self.dataMArray = [[NSMutableArray alloc] initWithObjects: dict, nil];
            }
            else {
                self.dataMArray = [NSMutableArray arrayWithArray:(NSMutableArray *)dict];
            }

            [self.tb reloadData];
            _tb.contentOffset =  CGPointMake(0, currentY);

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
}


- (void)selectItem:(UIButton *)button
{
    
    
    
    
    UITableViewCell *cell = (UITableViewCell *)[[[button superview]  superview] superview];
    
    
    if ( !iOS7) {
        cell = (UITableViewCell *)[[button superview]  superview];
    }
    
    
    NSIndexPath *indexPath = [_tb indexPathForCell:cell];
    
    
    //        type
    //
    NSDictionary *indexDict = self.dataMArray[indexPath.row];
    
    WKKViewController *kvc = [[WKKViewController alloc] initWithNibName:@"WKKViewController" bundle:nil];
    kvc.type =  3;
    kvc.orderID = self.dataMDict[@"Id"][@"text"];
    kvc.itemId = indexDict[@"id"][@"text"];
    
    [self.view addSubview:kvc.view];
    [self addChildViewController:kvc];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataMArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell3h";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [[Button share] addToView:cell.contentView addTarget:self rect:RectMake2x(1574, 35, 142, 76) tag:10909 action:@selector(selectItem:) imagePath:@"take_photo" highlightedImagePath:nil SelectedImagePath:@"take_photo"];
        UISwitch *sw = [[UISwitch alloc] initWithFrame:RectMake2x(1374, 33, 142, 76*2)];
        sw.tag = 19090;
        [sw addTarget:self action:@selector(swValueChange:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:sw];
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        
        l.frame = RectMake2x( 1674, 0, 20,14090);
        l.numberOfLines = 0;
        l.tag = 2014;
        
        [cell.contentView addSubview:l];
    }
    
    UILabel *l = (UILabel *)[cell.contentView viewWithTag:2014];
    l.text = @"";
    UISwitch *sw = (UISwitch *)[cell.contentView viewWithTag:19090];
    sw.on = NO;
    NSDictionary *dict = self.dataMArray[indexPath.row];
    
    NSString *dept_Str =  dict[@"Dept"][@"text"];
    if ([dept_Str isEqualToString:@"wu"]) {
        
        dept_Str = @"无";
    }
    else if ([dept_Str isEqualToString:@"yingxiao"]) {
        
        dept_Str = @"营销中心";
    }
    else if ([dept_Str isEqualToString:@"gongcheng"]) {
        
        dept_Str = @"工程部";
    }
    else if ([dept_Str isEqualToString:@"dingdan"]) {
        
        dept_Str = @"订单中心";
    }
    else if ([dept_Str isEqualToString:@"kefu"]) {
        
        dept_Str = @"客服部";
    }
    
    
    NSString *text = [NSString stringWithFormat:@"%@[%@]",  dict[@"transactionContent"][@"text"], dept_Str];
    cell.textLabel.text = text;
    cell.detailTextLabel.text = dict[@"createDate"][@"text"];
    
    if ( [dict[@"isWarn"][@"text"]  isEqualToString:@"0" ]) {
        sw.on = NO;
    }
    else {
        sw.on = YES;
    }
    
    
    if ([dict[@"ImgCount"][@"text"] isEqualToString:@"0"]) {
        
    }
    else {
        l.text = dict[@"ImgCount"][@"text"];
    }

    return cell;
    
    
}

#pragma mark - Table view delegate

- (void)swValueChange:(id)sender
{
    
    UISwitch *sw = (UISwitch *)sender;
    
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview]  superview] superview];
    if ( !iOS7) {
        cell = (UITableViewCell *)[[sender superview]  superview];
    }
    NSIndexPath *indexPath = [_tb indexPathForCell:cell];
    NSDictionary *dict = self.dataMArray[indexPath.row];
    
    NSString *alertStr = [NSString stringWithFormat:@"0"];
    if (sw.on ) {
        alertStr = @"1";
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSDictionary *parameters = @{ @"id":  dict[@"id"][@"text"],
                                  @"isWarn": alertStr,
                                  @"dept": @"wu"};

    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/UpdateWarn", KHomeUrl];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        NSError *parseError = nil;
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        if ( [s isEqualToString:@"成功"]) {
            [SVProgressHUD dismiss];
            
            currentY = _tb.contentOffset.y;
            
            [self getTemp];

        }
        else {
            
            [SVProgressHUD dismiss];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    

    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}





@end
