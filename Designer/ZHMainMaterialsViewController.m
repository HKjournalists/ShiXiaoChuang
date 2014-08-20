//
//  ZHBaseMaterialsViewController.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-24.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHMainMaterialsViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XMLReader.h"
#import "WKKViewController.h"

@interface ZHMainMaterialsViewController ()

@end

@implementation ZHMainMaterialsViewController


- (void)submit:(UIButton *)button
{
    
    
    [SVProgressHUD showWithStatus:@"正在提交数据..." maskType:SVProgressHUDMaskTypeGradient];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    //    1875
    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/addBaseMaterials"];
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/addBaseMaterials", KHomeUrl];

    
//    <State>
//    <State>
//    <itemfID>008882B7D3744E9FAA03D70D9B076629</itemfID>
//    <ISPass>0</ISPass>
//    <ISArrive>1</ISArrive>
//    </State>
//    <State>
//    <itemfID>00C7EBA586984C11B224D999F3DF9241</itemfID>
//    <ISPass>1</ISPass>
//    <ISArrive>0</ISArrive>
//    </State>
//    </State>
//
    
    NSString *str = [NSString stringWithFormat:@"<State><State><itemfID>%@</itemfID><ISPass>1</ISPass></State></State>", self.dataMArray[currentIndex][@"itemfID"][@"text"]];


    NSString *_dataString = [[str stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
    stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    NSDictionary *parameters = @{@"str":_dataString
                                 };
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *parseError = nil;
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        bool b = [xmlDictionary[@"boolean"] objectForKey:@"text"];
        //        NSDictionary *dict = [XMLReader dictionaryForXMLString:s error:&parseError];
        
        if (  ! b  ) {
            [SVProgressHUD dismiss];
            
            [[Message share] messageAlert:[NSString stringWithFormat:@"%i", b]];
            
            return ;
        }
        else {
            [SVProgressHUD showWithStatus:@"提交成功" maskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD performSelector:@selector(dismiss) withObject:nil afterDelay:1];
            currentButton.selected =  YES;
            

            [self getTable:@""];

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    

    
}

- (void)getTable:(NSString *)string
{
    
    
    [self.dataMArray removeAllObjects];
    [tb reloadData];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/GetBaseMaterials"];
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/GetBaseMaterials", KHomeUrl];

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

            
            
            self.dataMArray = dict[@"Materials"][@"Materials"];
            
            [tb reloadData];

 
            
            [tb scrollRectToVisible:CGRectMake(0, currentOffset, tb.frame.size.width, tb.frame.size.height) animated:NO];
            
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
    currentOffset = 0;
    
    
    
    tb = [[UITableView alloc] initWithFrame:RectMake2x(0 , 140, 2048, 1396) style:UITableViewStylePlain];
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
 
    
    
    [[ImageView share] addToView:self.view imagePathName:@"标题图-基材验收" rect:RectMake2x(40, 80, 230, 40)];
    
    
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

#pragma mark - alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        
        
        [self submit:nil];
        
        
        
    }
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
    kvc.type =  9 ;
    kvc.orderID = self.dataMDict[@"Id"][@"text"];
    kvc.itemId = indexDict[@"itemfID"][@"text"];
    
    [self.view addSubview:kvc.view];
    [self addChildViewController:kvc];
    
}


- (void)selectItem:(UIButton *)button
{
    
    if (button.selected == YES) {
        
        [[Message share] messageAlert:@"已确定的基材不可更改！"];

        return;
    }
    
    currentButton =  button;
    
    
    UITableViewCell *cell = (UITableViewCell *)[[[button superview]  superview] superview];
    
    
    if ( !iOS7) {
        cell = (UITableViewCell *)[[button superview]  superview];
    }
    
    currentIndex = [tb indexPathForCell:cell].row;
    currentOffset =  tb.contentOffset.y;
    
    
    [[Message share] messageAlert:@"请您确定该基材验证合格吗？" delegate:self];
    
    
    
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
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] init];
    
    headerView.backgroundColor = [UIColor whiteColor];
    [[ImageView share] addToView:headerView imagePathName:@"表格-标题黄线" rect:CGRectMake(0, 44, 1024, 1)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 1968/2, 44)];
    label.font = [UIFont boldSystemFontOfSize:25];
    
    [headerView addSubview:label];
    
    NSArray *header = @[@"材料名称", @"材料规格", @"单位",  @"数量", @"是否验收合格", @"照片"];
    

    for (int i = 1; i < 7; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 0, 0, 544, 90);
        }
        if (i == 2) {
            l.frame = RectMake2x( 544, 0, 543, 90);
        }
        if (i == 3) {
            l.frame = RectMake2x( 1087, 0, 244, 90);
        }
        if (i == 4) {
            l.frame = RectMake2x( 1331, 0, 243, 90);
        }
        if (i == 5) {
            l.frame = RectMake2x( 1574, 0, 394, 90);
        }
        if (i == 6) {
            l.frame = RectMake2x( 1904, 0, 94, 90);
        }
        
        l.text = header[i-1];
        [headerView addSubview:l];
    }
    
    
//    label.text = self.dataMArray[section][0][@"CheckType"][@"text"];
    return headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (self.dataMArray.count == section +1 ) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1618/2, 45)];
        
//        [[Button share] addToView:footer addTarget:self rect:RectMake2x(686, 40, 246, 96) tag:1000 action:@selector(submit:) imagePath:@"按钮-提交表单"];
//        
        return footer;
        
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
    
    
    for (int i = 1; i < 5 ; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        l.tag = i +100;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 524, 150);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 544, 0, 543, 90);
        }
        
        if (i == 3) {
            l.frame = RectMake2x( 1087, 0, 244, 90);
        }
        
        if (i == 4) {
            l.frame = RectMake2x( 1331, 0, 243, 90);
        }
//        if (i == 5) {
//            l.frame = RectMake2x( 1574, 0, 394, 90);
//        }
        
        [cell.contentView addSubview:l];
    }
    
    
    
    if ( SharedAppUser.isSignalIn == YES ) {
        
        
        [[Button share] addToView:cell.contentView addTarget:self rect:RectMake2x(1674, 3, 142, 83) tag:10909 action:@selector(selectItem:) imagePath:@"按钮-签到-00" highlightedImagePath:nil SelectedImagePath:@"按钮-签到-01"];
        
        
        [[Button share] addToView:cell.contentView addTarget:self rect:RectMake2x(1908, 3, 142, 83) tag:10907 action:@selector(takenPhoto:) imagePath:@"take_photo" highlightedImagePath:nil SelectedImagePath:@"take_photo"];
        
        
    }
    UILabel *l = [[UILabel alloc] init];
    l.textAlignment = NSTextAlignmentCenter;
    
    l.frame = RectMake2x( 2008, 0, 20, 90);
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
    
    UIButton *button  = (UIButton *)[cell.contentView viewWithTag:10909];
    
    
    NSDictionary *dict =self.dataMArray [indexPath.row];
    
    UILabel *l1 = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *l2 = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *l3 = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *l4 = (UILabel *)[cell.contentView viewWithTag:104];
    
    
    l1.text = @"";
    l2.text = @"";
    l3.text = @"";
    l4.text = @"";
    
    l1.text = dict [@"MaDec"][@"text"];
    l2.text = dict [@"MaSpec"][@"text"];
    l3.text = dict [@"MaUnit"][@"text"];
    l4.text = dict[@"CheckQuantity"][@"text"];
    UILabel *l = (UILabel *)[cell.contentView viewWithTag:2014];
    l.text = @"";
    
    if (SharedAppUser.isSignalIn) {

        if ([dict[@"IsPass"][@"text"] isEqualToString:@"1"]) {
            
            button.selected = YES;
        }
        else {
            button.selected = NO;

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


@end
