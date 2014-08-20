//
//  ZHBaseMaterialsViewController.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-24.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHBiShuiCheckViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XMLReader.h"



@interface ZHBiShuiCheckViewController ()

@end

@implementation ZHBiShuiCheckViewController

#pragma mark - alert

- (void)saveCheckContent
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [self saveCheckContent];

    }
}

#pragma mark - network
- (void)submitTable:(UIButton *)button
{
    
    [SVProgressHUD showWithStatus:@"正在提交数据..." maskType:SVProgressHUDMaskTypeGradient];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
    
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/"];
    
    
    NSDictionary *parameters = @{@"orderId": self.dataMDict[@"Id"][@"text"],
                                 @"monitorId": SharedAppUser.ID ,
                                 @"monitorName": SharedAppUser.account};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSError *parseError = nil;
        
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        
        NSString * b = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        
        
        
        if (  [b isEqualToString:@"验收成功"]) {
            [SVProgressHUD dismiss];
            button.enabled = NO;
            [[Message share] messageAlert:[NSString stringWithFormat:@"验收成功"]];
            
            
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[Cookie getCookie:SharedAppUser.currentConstruction]];
            
          [Cookie setCookie:SharedAppUser.currentConstruction value:dict];
            return ;
        }
        else {
            [SVProgressHUD dismiss];
            
            
            [[Message share] messageAlert:[NSString stringWithFormat:@"%@", b]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    
    
}



- (void)submit:(UIButton *)button
{
    NSLog(@"submit");
    
    NSMutableDictionary *dict = [Cookie getCookie:SharedAppUser.currentConstruction];
    
    bool isSubmit = YES;
    for (NSMutableArray *a in self.dataMArray) {
        
        for (NSDictionary *currentDict in a) {
            if ( ! [dict[currentDict[@"Id"][@"text"]] isEqualToString:@"1"])
            {
                isSubmit = NO;
            }
        }
    }
    
    
    if (isSubmit) {
        
        [self submitTable:button];
        
        
        
        
    }
    else {
        [[Message share] messageAlert:@"只有全部为确认状态时才可以提交验收成功"];
    }
}


- (void)getTable:(NSString *)string
{
    
    
    [self.dataMArray removeAllObjects];
    [tb reloadData];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
    
    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/GetTables"];
    
    
    NSDictionary *parameters = @{@"tableName": @"闭水验收单",
                                 @"orderId": @""};
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
            
            
            
            self.dataMArray = dict[@"ArrayOfAPPCheckProject"][@"APPCheckProject"];
            
            [tb reloadData];

            
            
            
            [tb scrollRectToVisible:CGRectMake(0, currentOffsetY, tb.frame.size.width, tb.frame.size.height) animated:NO];
            

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    
    
    
}




#pragma mark - 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    currentIndex = 0;
    currentOffsetY  = 0;
    
    tb = [[UITableView alloc] initWithFrame:RectMake2x(40 , 140, 1968, 1396) style:UITableViewStylePlain];
    tb.backgroundColor = [UIColor clearColor];
    tb.layer.masksToBounds = YES;
    tb.layer.cornerRadius = 6;
    //    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb.dataSource = self;
    tb.delegate = self;
    
    [self.view addSubview:tb];
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    [[Button share] addToView:self.view addTarget:self rect:RectMake2x(1942,  61, 71, 63) tag:1 action:@selector(back:) imagePath:@"按钮-返回1"];
 
    
    
    UIButton *b = [[Button share] addToView:self.view addTarget:self rect:RectMake2x(40, 80, 230, 40) tag:1 action:nil ];
    
    [b setTitle:@"闭水验收单" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:YES];
    
    [self getTable:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action

- (void)selectItem:(UIButton *)button
{
    
    

    
    button.selected = YES;
    NSMutableDictionary *dict =  [Cookie getCookie:SharedAppUser.currentConstruction];
    
    if ( ! dict ) {
        dict  = [[NSMutableDictionary alloc] init];
    }
    dict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    
    
    
    UITableViewCell *cell = (UITableViewCell *)[[[button superview]  superview] superview];
    if ( !iOS7) {
        cell = (UITableViewCell *)[[button superview]  superview];
    }
    NSIndexPath *indexPath = [tb indexPathForCell:cell];
    
    
    NSDictionary *indexDict = self.dataMArray[indexPath.row];
    
    
    if ([dict[indexDict[@"Id"][@"text"]] isEqualToString:@"1"]) {
        
        [dict setValue:@"0" forKey:indexDict[@"Id"][@"text"]];
        button.selected = NO;
    }
    else {
        
        [dict setValue:@"1" forKey:indexDict[@"Id"][@"text"]];
        button.selected = YES;
        
    }
    
    
    [Cookie setCookie:SharedAppUser.currentConstruction value:dict];
    
    
    
}

- (void)openProductDetail:(UIButton *)button
{
    
    UITableViewCell *cell = (UITableViewCell *)[[[button superview]  superview] superview];
    
    
    if ( !iOS7) {
        cell = (UITableViewCell *)[[button superview]  superview];
    }
    
    NSIndexPath *indexPath = [tb indexPathForCell:cell];
    
    
    int index = (indexPath.row*3)  + button.tag - 301;
    
    NSString *cate_id = [NSString stringWithFormat:@"%d", [[[self.dataMArray objectAtIndex:index] objectForKey:@"id"] intValue]];
    
    
    
    NSMutableArray *products = [[ZHDBData share] getCasesDetailForC_Id:cate_id];
    
    
    if (products.count == 0) {
        [[Message share] messageAlert:@"敬请期待！"];
        return;
    }
    
    //    ZHCaseDetailViewController  *lvc = [[ZHCaseDetailViewController alloc] init];
    //    lvc.dataMArray = products;
    //    lvc.dataMDict = [self.dataMArray objectAtIndex:index] ;
    //
    //    [self.view addSubview:lvc.view];
    //    [self addChildViewController:lvc];
    //
    //    lvc.view.alpha = 0;
    //
    //    [UIView animateWithDuration:KLongDuration animations:^{
    //        lvc.view.alpha = 1;
    //    }];
    //
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    

    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] init];
    
    headerView.backgroundColor = [UIColor whiteColor];
    [[ImageView share] addToView:headerView imagePathName:@"表格-标题黄线" rect:CGRectMake(0, 44,1968/2, 1)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 1968/2, 44)];
    label.font = [UIFont boldSystemFontOfSize:25];
    
    [headerView addSubview:label];
    
    NSArray *header = @[@"检查内容", @"检查类型", @"是否验证合格" ];
    

    for (int i = 1; i < 4; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 1365, 90);
        }
        if (i == 2) {
            l.frame = RectMake2x( 1085, 0, 384, 90);
        }
        
        if (i == 3) {
            l.frame = RectMake2x( 1668, 0, 239, 100);
        }
        
        if (i == 4) {
            l.frame = RectMake2x( 870, 0, 100, 90);
        }
        if (i == 5) {
            l.frame = RectMake2x( 970, 0, 404, 90);
        }
        if (i == 6) {
            l.frame = RectMake2x( 1374, 0, 195, 90);
        }
        if (i == 7) {
            l.frame = RectMake2x( 1569, 0, 199, 90);
        }
        if (i == 8) {
            l.font = [UIFont systemFontOfSize:15];
            l.frame = RectMake2x( 1768, 0, 199, 90);
        }
        l.text = header[i-1];
        [headerView addSubview:l];
    }
    
    
//    label.text = self.dataMArray[section][0][@"CheckType"][@"text"];
    return headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1618/2, 45)];
        [[Button share] addToView:footer addTarget:self rect:RectMake2x(686, 40, 246, 96) tag:1000 action:@selector(submit:) imagePath:@"按钮-提交表单"];


        
        if ( SharedAppUser.isSignalIn == YES ) {
            return footer;
        }
        else {
            return nil;
        }

        
    
    
    return nil;
    
}

- (UITableViewCell *)cell3Height
{
    
    static NSString *CellIdentifier = @"Cell3h";
    
    UITableViewCell *cell = [tb dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[ImageView share] addToView:cell.contentView imagePathName:@"productlist_cell_bg" rect:RectMake2x(0, 0, 1900, 388)];
    
    
//    l.frame = RectMake2x( 1085, 0, 384, 90);
//}
//
//if (i == 3) {
//    l.frame = RectMake2x( 1668, 0, 199, 100);
    
    for (int i = 1; i < 9; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 1000, 90);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 1085, 0, 384, 90);
        }
        
        if (i == 3) {
            l.frame = RectMake2x( 1668, 0, 199, 100);
        }
        
        if (i == 4) {
            l.frame = RectMake2x( 870, 0, 120, 90);
        }
        if (i == 5) {
            l.frame = RectMake2x( 970, 0, 404, 90);
        }
        if (i == 6) {
            l.frame = RectMake2x( 1344, 0, 255, 90);
        }
        if (i == 7) {
            l.frame = RectMake2x( 1569, 0, 199, 90);
        }
        if (i == 8) {
            l.frame = RectMake2x( 1768, 0, 199, 90);
        }
        l.tag = i+100;
        [cell.contentView addSubview:l];
    }

    
    
    if ( SharedAppUser.isSignalIn == YES ) {
        
    
        
        [[Button share] addToView:cell.contentView addTarget:self rect:RectMake2x(1590, 3, 142, 83) tag:10908 action:@selector(selectItem:) imagePath:@"按钮-签到-00" highlightedImagePath:nil SelectedImagePath:@"按钮-签到-01"];
//        [[Button share] addToView:cell.contentView addTarget:self rect:RectMake2x(1788, 3, 142, 83) tag:10909 action:@selector(selectItem:) imagePath:@"按钮-签到-00" highlightedImagePath:nil SelectedImagePath:@"按钮-签到-01"];

        
    }
    else {
        return nil;
    }

     return cell;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell3h";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [self cell3Height];
    }
    
    UIButton *button1  = (UIButton *)[cell.contentView viewWithTag:10908];
//    UIButton *button2  = (UIButton *)[cell.contentView viewWithTag:10909];

    
    NSDictionary *dict =self.dataMArray [indexPath.row];
    
    UILabel *l1 = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *l2 = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *l3 = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *l4 = (UILabel *)[cell.contentView viewWithTag:104];
    
    UILabel *l5 = (UILabel *)[cell.contentView viewWithTag:105];
    UILabel *l6 = (UILabel *)[cell.contentView viewWithTag:106];
//    UILabel *l7 = (UILabel *)[cell.contentView viewWithTag:107];
//    UILabel *l8 = (UILabel *)[cell.contentView viewWithTag:108];
    
    
    
    l1.text = @"";
    l2.text = @"";
    l3.text = @"";
    l4.text = @"";
    l5.text = @"";
    l6.text = @"";
//    l7.text = @"";
//    l8.text = @"";
    
    l1.text = dict [@"CheckContext"][@"text"];
    l2.text = dict [@"CheckType"][@"text"];
//    l3.text = dict [@"ProcessType"][@"text"];
//    l4.text = dict[@"CheckQuantity"][@"text"];
//    l5.text = dict[@"Attribute1"][@"text"];
//    l6.text = dict[@"PlanToTime"][@"text"];
//    
    
//    
//    if (SharedAppUser.isSignalIn) {
//        NSMutableDictionary *currentDict =  self.dataMArray[indexPath.row];
//        NSMutableDictionary *dict = [Cookie getCookie:SharedAppUser.currentConstruction];
//
//        if ([dict[currentDict[@"Id"][@"text"]] isEqualToString:@"1"]  ) {
//            button1.selected = YES;
//        }
//        else {
//            button1.selected = NO;
//        }
//    }

    return cell;
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


@end
