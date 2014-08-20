//
//  ZHBaseMaterialsViewController.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-24.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHLicenseViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XMLReader.h"
#import "WKKViewController.h"

@interface ZHLicenseViewController ()

@end

@implementation ZHLicenseViewController

#pragma mark - alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{


    if (buttonIndex == 1) {
    

        UITableViewCell *cell = (UITableViewCell *)[[[currentButton superview]  superview] superview];
        if ( !iOS7) {
            cell = (UITableViewCell *)[[currentButton superview]  superview];
        }
        NSIndexPath *indexPath = [tb indexPathForCell:cell];

        NSMutableDictionary *d = [self.dataMArray objectAtIndex:indexPath.row];
        
        
        if (currentButton.tag == 10908) {
            
            [d setValue:@{@"text": @"1"} forKey:@"Has"];
        }
        else {
            [d setValue:@{@"text": @"1"} forKey:@"IsOk"];
        }
        currentButton.selected = YES;
        
        currentButton = nil;

    }
}

#pragma mark - network

- (NSString *)arrryToString
{
    
//    {
//        Has =     {
//            text = 1;
//        };
//        Id =     {
//        };
//        IsOk =     {
//        };
//        ItemId =     {
//            text = 20140507001;
//        };
//        Name =     {
//            text = "\U95e8\U8d34";
//        };
//        Remark =     {
//        };
//    }
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"<ArrayOfConstructionLicense>"];

    for (NSDictionary *dict in self.dataMArray) {
        
        [str appendString:@"<ConstructionLicense>"];
        
        
//        [str appendString:@"<Id>"];
//        [str appendFormat:@"%@", dict[@"Id"][@"text"]];
//        [str appendString:@"</Id>"];

        [str appendString:@"<Name>"];
        [str appendFormat:@"%@", dict[@"Name"][@"text"]];
        [str appendString:@"</Name>"];

        [str appendString:@"<Has>"];
        if ([dict[@"Has"][@"text"] isEqualToString:@"1"]) {
            [str appendFormat:@"%@", @"1"];
        }
        else {
            [str appendFormat:@"%@", @"0"];
        }
//        [str appendFormat:@"%@", dict[@"Has"][@"text"]];
        [str appendString:@"</Has>"];
        
        
        [str appendString:@"<IsOk>"];
        if ([dict[@"IsOk"][@"text"] isEqualToString:@"1"]) {
            [str appendFormat:@"%@", @"1"];
        }
        else {
            [str appendFormat:@"%@", @"0"];
        }
        [str appendString:@"</IsOk>"];
        
        

        [str appendString:@"<ItemId>"];
        [str appendFormat:@"%@", dict[@"ItemId"][@"text"]];
        [str appendString:@"</ItemId>"];
        
        [str appendString:@"<Remark>"];
//        [str appendFormat:@"%@", dict[@"Remark"][@"text"]];
        if (dict[@"Remark"][@"text"]) {
            [str appendFormat:@"%@", dict[@"Remark"][@"text"]];
        }
        else {
            [str appendFormat:@"%@", @""];
        }
        [str appendString:@"</Remark>"];
        
        [str appendString:@"</ConstructionLicense>"];
        
    }
    [str appendString:@"</ArrayOfConstructionLicense>"];

    
    return str;
}

- (void)submit:(UIButton *)button
{
    
    
    [SVProgressHUD showWithStatus:@"正在提交数据..." maskType:SVProgressHUDMaskTypeGradient];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    

    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/AddLicenseStr"];
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/AddLicenseStr", KHomeUrl];
    NSString *str = [self arrryToString];

    

    NSString *_dataString = [[str stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
                             stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];

    NSDictionary *parameters = @{@"str": _dataString,
                                 @"orderId": self.dataMDict[@"Id"][@"text"] };
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *parseError = nil;
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        bool s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        if (  !s  ) {
            [SVProgressHUD dismiss];
            [[Message share] messageAlert:[NSString stringWithFormat:@"%i", s]];
            
            return ;
        }
        else {
            
            
            [SVProgressHUD showWithStatus:@"提交成功" maskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD performSelector:@selector(dismiss) withObject:nil afterDelay:1];
            
            
            [self getTable:@""];
            
            currentButton.selected = YES;
            currentButton = nil;

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        currentButton = nil;

        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    

}

- (void)cheeckTable
{

    bool isHidden = NO;
    
    

    for (int i = 0 ; i < self.dataMArray.count; i ++) {
        
        NSDictionary *dict = self.dataMArray[i];
        
        if ([dict[@"Has"][@"text"] isEqualToString:@"1"]) {
            isHidden = YES;
            
            break;
        }
        
        if ([dict[@"IsOk"][@"text"] isEqualToString:@"1"]) {
            isHidden = YES;
            
            break;
        }
        
        if (  dict[@"Remark"][@"text"] != nil) {
            isHidden = YES;
            
            break;
        }
        
        
    }
    
    
    
    
    if (  isHidden  ) {
        footButton.alpha = 0;
    }
    else {
        footButton.alpha = 1;
    }
}

- (void)getTable:(NSString *)string
{
    
    
    [self.dataMArray removeAllObjects];
    [tb reloadData];
    

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/GetLicenseByOrderId"];
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/GetLicenseByOrderId", KHomeUrl];

    NSDictionary *parameters = @{@"orderId": self.dataMDict[@"Id"][@"text"]};
    
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
            
            
            
            self.dataMArray = dict[@"ArrayOfConstructionLicense"][@"ConstructionLicense"];

            [tb reloadData];

            [self cheeckTable];

            
            
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
    
    array = [[NSMutableArray alloc] init];
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
    
    [b setTitle:@"施工许可证" forState:UIControlStateNormal];
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

- (void)takenPhoto:(UIButton *)button
{
    UITableViewCell *cell = (UITableViewCell *)[[[button superview]  superview] superview];
    if ( !iOS7) {
        cell = (UITableViewCell *)[[button superview]  superview];
    }
    NSIndexPath *indexPath = [tb indexPathForCell:cell];

    NSDictionary *indexDict = self.dataMArray[indexPath.row];
    
    WKKViewController *kvc = [[WKKViewController alloc] initWithNibName:@"WKKViewController" bundle:nil];
    kvc.type =  11 ;
    kvc.orderID = self.dataMDict[@"Id"][@"text"];
    kvc.itemId = indexDict[@"ItemId"][@"text"];
    
    [self.view addSubview:kvc.view];
    [self addChildViewController:kvc];

}

- (void)selectItem:(UIButton *)button
{
    
    
    
    
    if (button.selected == YES) {
        
        [[Message share] messageAlert:@"已确认过的信息不可更改！"];
        
        return;
    }
    
    
    if (button.tag == 10908) {
        
        //      到场
        [[Message share] messageAlert:@"您确定该项目有是吗？" delegate:self];
    }
    else if (button.tag == 10909) {
        
        //      合格
        [[Message share] messageAlert:@"您确定该项目合格是吗？" delegate:self];
    }
    
    
    
    currentButton =  button;
    
    
    UITableViewCell *cell = (UITableViewCell *)[[[button superview]  superview] superview];
    
    
    if ( !iOS7) {
        cell = (UITableViewCell *)[[button superview]  superview];
    }
    
    currentIndex = [tb indexPathForCell:cell].row;
    currentOffsetY =  tb.contentOffset.y;

    
    
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
    
    if (self.dataMArray.count == section +1) {
        return 100;
    }
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
    
    NSArray *header = @[@"名称", @"有无", @"是否合格",  @"备注", @"拍照" ];
    

    for (int i = 1; i < 6; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 365, 90);
        }
        if (i == 2) {
            l.frame = RectMake2x( 385, 0, 384, 90);
        }
        
        if (i == 3) {
            l.frame = RectMake2x( 769, 0, 201, 90);
        }
        
        if (i == 4) {
            l.frame = RectMake2x( 970, 0, 600, 90);
        }
        if (i == 5) {
            l.frame = RectMake2x( 1569, 0, 404, 90);
        }
        if (i == 6) {
            l.frame = RectMake2x( 1774, 0, 195, 90);
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
    
    
    if ( SharedAppUser.isSignalIn == YES ) {

        
        if ( ! footButton) {
            footButton = [[Button share] addToView:footer addTarget:self rect:RectMake2x(686, 40, 246, 96) tag:1000 action:@selector(submit:) imagePath:@"按钮-提交表单"];
        }
        else {
            [footer addSubview:footButton];
        }
        
    }
    return footer;
}

- (UITableViewCell *)cell3Height
{
    
    static NSString *CellIdentifier = @"Cell3h";
    
    UITableViewCell *cell = [tb dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[ImageView share] addToView:cell.contentView imagePathName:@"productlist_cell_bg" rect:RectMake2x(0, 0, 1900, 388)];
    
    
    
    
    for (int i = 1; i < 9; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 365, 90);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 385, 0, 384, 90);
        }
        
        if (i == 3) {
            l.frame = RectMake2x( 769, 0, 101, 90);
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
        
    
        UITextField *tf = [[UITextField alloc] initWithFrame:RectMake2x(1069, 3, 442, 83)];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.placeholder =  @"点击添加备注";
        tf.tag = 2001;
        tf.delegate = self;
        [cell.contentView addSubview:tf];
        
        [[Button share] addToView:cell.contentView addTarget:self rect:RectMake2x(505, 3, 142, 83) tag:10908 action:@selector(selectItem:) imagePath:@"按钮-签到-00" highlightedImagePath:nil SelectedImagePath:@"按钮-签到-01"];
        [[Button share] addToView:cell.contentView addTarget:self rect:RectMake2x(769, 3, 142, 83) tag:10909 action:@selector(selectItem:) imagePath:@"按钮-签到-00" highlightedImagePath:nil SelectedImagePath:@"按钮-签到-01"];
        
        [[Button share] addToView:cell.contentView addTarget:self rect:RectMake2x(1768, 3, 142, 83) tag:10909 action:@selector(takenPhoto:) imagePath:@"take_photo" highlightedImagePath:nil SelectedImagePath:@"take_photo"];
        
    }

    
    UILabel *l = [[UILabel alloc] init];
    l.textAlignment = NSTextAlignmentCenter;
    
    l.frame = RectMake2x( 1868, 0, 20, 90);
    l.numberOfLines = 0;
    l.tag = 2014;
    
    [cell.contentView addSubview:l];

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
    UIButton *button2  = (UIButton *)[cell.contentView viewWithTag:10909];

    
    NSDictionary *dict =self.dataMArray [indexPath.row];
    
    UILabel *l1 = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *l2 = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *l3 = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *l4 = (UILabel *)[cell.contentView viewWithTag:104];
    
    UILabel *l5 = (UILabel *)[cell.contentView viewWithTag:105];
    UILabel *l6 = (UILabel *)[cell.contentView viewWithTag:106];
//    UILabel *l7 = (UILabel *)[cell.contentView viewWithTag:107];
//    UILabel *l8 = (UILabel *)[cell.contentView viewWithTag:108];
    UILabel *l = (UILabel *)[cell.contentView viewWithTag:2014];
    l.text = @"";
    
    l1.text = @"";
    l2.text = @"";
    l3.text = @"";
    l4.text = @"";
    l5.text = @"";
    l6.text = @"";
//    l7.text = @"";
//    l8.text = @"";
    
    l1.text = dict [@"Name"][@"text"];
//    l2.text = dict [@"Has"][@"text"];
//    l3.text = dict [@"Remark"][@"text"];
//    l4.text = dict[@"CheckQuantity"][@"text"];
//    l5.text = dict[@"Attribute1"][@"text"];
    
//    Has =     {
//    };
//    Id =     {
//    };
//    IsOk =     {
//    };
//    ItemId =     {
//        text = 20140507001;
//    };
//    Remark =     {
//    };
    
    if (SharedAppUser.isSignalIn) {
        UITextField *tf = (UITextField *)[cell.contentView viewWithTag:2001];
        tf.text = dict[@"Remark"][@"text"];

        if ([dict[@"Has"][@"text"] isEqualToString:@"1"]) {
            
            button1.selected = YES;

        }
        else {
            button1.selected = NO;
        }
        
        if ([dict[@"IsOk"][@"text"] isEqualToString:@"1"]) {
            
            button2.selected = YES;
            
        }
        else {
            button2.selected = NO;
        }
        
    }
    
    if ([dict[@"ImgCount"][@"text"] isEqualToString:@"0"]) {
        
    }
    else {
        l.text = dict[@"ImgCount"][@"text"];
    }

    return cell;
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    UITableViewCell *cell = (UITableViewCell *)[[[textField superview]  superview] superview];
    if ( !iOS7) {
        cell = (UITableViewCell *)[[textField superview]  superview];
    }
    
    
    NSIndexPath *indexPath = [tb indexPathForCell:cell];
    NSMutableDictionary *d = [self.dataMArray objectAtIndex:indexPath.row];
    
    
    [d setValue:@{@"text": textField.text} forKey:@"Remark"];


}

@end
