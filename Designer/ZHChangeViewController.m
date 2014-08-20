//
//  ZHBaseMaterialsViewController.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-24.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHChangeViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XMLReader.h"


@interface ZHChangeViewController ()

@end

@implementation ZHChangeViewController


- (void)getTable:(int)num
{
    
    
    [self.dataMArray removeAllObjects];
    [tb reloadData];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
    
//    NSMutableString *url = [NSMutableString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/"];
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/", KHomeUrl];

    switch (currentTable) {
        case 1:
            [url appendString:@"GetProductChange"];
            break;
        case 2:
            [url appendString:@"GetCraftChange"];
            break;
//        case 3:
//            [url appendString:@""];
            break;
        case 3:
            [url appendString:@"GetDisProductChange"];
            break;
        default:
            break;
    }
    
  
    NSDictionary *parameters = @{@"changeId": self.dataMDict[@"Id"][@"text"]};

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
            
            
            switch (currentTable) {
                case 1:
                    self.dataMArray = dict[@"ArrayOfChangeProduct"][@"ChangeProduct"];
  
                    break;
                case 2:
                    self.dataMArray = dict[@"ArrayOfChangeCraft"][@"ChangeCraft"];
                    break;
                case 3:
                    self.dataMArray = dict[@"ArrayOfChangeDisProduct"][@"ChangeDisProduct"];
                    break;
                case 4:

                    self.dataMArray = dict[@"ArrayOfChangeDisProduct"][@"ChangeDisProduct"];
                    NSLog(@"%@", self.dataMArray );
                    break;
                default:
                    break;
            }
            if ([self.dataMArray isKindOfClass:[NSMutableDictionary class]]) {
                self.dataMArray =[ [NSMutableArray alloc] initWithObjects:self.dataMArray , nil];
            }
            
            [tb reloadData];
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

- (void)changeTable:(UIButton *)button
{
    
    for (int i = 1; i< 5; i++) {
        
        UIButton *b =(UIButton *)[self.view viewWithTag:i];
        b.selected = NO;
    }
    button.selected = YES;
    
    
    currentTable = button.tag;
    
    
    [self getTable:0];
}

- (void)loadView
{
    [super loadView];
    currentTable = 1;
    
    tb = [[UITableView alloc] initWithFrame:RectMake2x(40 , 140, 1968, 1396) style:UITableViewStylePlain];
    tb.backgroundColor = [UIColor clearColor];
    tb.layer.masksToBounds = YES;
    tb.layer.cornerRadius = 6;
    //    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb.dataSource = self;
    tb.delegate = self;
    
    [self.view addSubview:tb];
    
    
    int x = 69 + 289;
    
    NSArray *s = @[@"按钮-材料变更单", @"按钮-工艺变更单", @"按钮-折项"];
    
    for ( int i = 0 ; i< 3; i ++) {
        NSString *name = [NSString stringWithFormat:@"%@-0", s[i]];
        NSString *nameS = [NSString stringWithFormat:@"%@-1", s[i]];
        
        UIButton *b =  [[Button share] addToView:self.view addTarget:self rect:RectMake2x(40+x*i, 70, 289, 70) tag:i+1 action:@selector(changeTable:)
                        imagePath:name
             highlightedImagePath:nameS
                SelectedImagePath:nameS];
        
        
        if (i == 0) {
            b.selected = YES;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    [[Button share] addToView:self.view addTarget:self rect:RectMake2x(1942,  61, 71, 63) tag:1 action:@selector(back:) imagePath:@"按钮-返回1"];
 
    
    
    
    
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
    return 0;
}


- (void)table1Header:(UIView *)cell
{
    NSArray *header = @[@"物料编号", @"物料描述", @"单位", @"数量", @"销售价", @"金额小记", @"备注"];

    for (int i = 1; i < 8; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 385, 90);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 426, 0, 384, 90);
        }
        if (i == 3) {
            l.frame = RectMake2x( 809-40, 0, 101, 90);
        }
        if (i == 4) {
            l.frame = RectMake2x( 910-40, 0, 100, 90);
        }
        if (i == 5) {
            l.frame = RectMake2x( 1010-40, 0, 161, 90);
        }
        if (i == 6) {
            l.frame = RectMake2x( 1171-40, 0, 160, 90);
        }
        if (i == 7) {
            l.frame = RectMake2x( 1331-40, 0, 677, 90);
        }
        
        l.text = header[i-1];
        [cell addSubview:l];
    }
    

}


- (void)table2Header:(UIView *)cell
{
    
    NSArray *header = @[@"工艺名称", @"单位", @"单价", @"数量", @"金额", @"备注"];

    for (int i = 1; i < 7 ; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        l.tag = i +100;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 528, 90);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 568-40, 0, 116, 90);
        }
        
        if (i == 3) {
            l.frame = RectMake2x( 684-40, 0, 116, 90);
        }
        if (i == 4) {
            l.frame = RectMake2x( 800-40, 0, 115, 90);
        }
        if (i == 5) {
            l.frame = RectMake2x( 915-40, 0, 116, 90);
        }
        if (i == 6) {
            l.frame = RectMake2x( 1031-40, 0, 977, 90);
        }
        
        
        l.text = header[i-1];
        [cell addSubview:l];
    }
}
- (void)table3Header:(UIView *)cell
{
        NSArray *header = @[ @"名称",@"编号"];
    
    for (int i = 1; i < 3 ; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        l.tag = i +100;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 980, 90);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 1024-40, 0, 984, 90);
        }
        

        
        
        l.text = header[i-1];
        [cell addSubview:l];
    }

}
- (void)table4Header:(UIView *)cell
{
    NSArray *header = @[@"类型", @"折价明细", @"套餐名称", @"折价销售", @"单位", @"数量", @"小计"];
    
    for (int i = 1; i < 8 ; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        l.tag = i +100;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 385, 90);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 440-40, 0, 400, 90);
        }
        
        if (i == 3) {
            l.frame = RectMake2x( 840-40, 0, 399, 90);
        }
        if (i == 4) {
            l.frame = RectMake2x( 1239-40, 0, 192, 90);
        }
        if (i == 5) {
            l.frame = RectMake2x( 1431-40, 0, 192, 90);
        }
        if (i == 6) {
            l.frame = RectMake2x( 1623-40, 0, 192, 90);
        }
        if (i == 7) {
            l.frame = RectMake2x( 1815-40, 0, 192, 90);
        }
        
        l.text = header[i-1];
        [cell addSubview:l];
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] init];
    
    headerView.backgroundColor = [UIColor whiteColor];
    [[ImageView share] addToView:headerView imagePathName:@"表格-标题黄线" rect:CGRectMake(0, 44,1968/2, 1)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 1968/2, 44)];
    label.font = [UIFont boldSystemFontOfSize:25];
    
    [headerView addSubview:label];
    
    
    switch (currentTable) {
        case 1:
            [self table1Header:headerView];
            break;
        case 2:
            [self table2Header:headerView];
            break;
        case 3:
            [self table4Header:headerView];
            break;
        case 4:
            [self table4Header:headerView];
            break;
            
        default:
            break;
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

- (void)table1:(UITableViewCell *)cell
{
    for (int i = 1; i < 8 ; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        l.tag = i +100;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 385, 140);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 425-40, 0, 384, 140);
            l.numberOfLines = 0;

        }
        
        if (i == 3) {
            l.frame = RectMake2x( 809-40, 0, 101, 140);
        }
        if (i == 4) {
            l.frame = RectMake2x( 910-40, 0, 100, 140);
        }
        if (i == 5) {
            l.frame = RectMake2x( 1010-40, 0, 161, 140);
        }
        if (i == 6) {
            l.frame = RectMake2x( 1171-40, 0, 160, 140);
        }
        if (i == 7) {
            l.frame = RectMake2x( 1331-40, 0, 677, 140);
            l.numberOfLines = 0;

        }
        
        [cell.contentView addSubview:l];
    }
    

}
- (void)table2:(UITableViewCell *)cell{
    for (int i = 1; i < 7 ; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        l.tag = i +100;
        
//        if ( i  ==1) {
//            l.frame = RectMake2x( 10, 0, 385, 140);
//            l.numberOfLines = 0;
//        }
//        if (i == 2) {
//            l.frame = RectMake2x( 568-40, 0, 384, 140);
//        }
//        
//        if (i == 3) {
//            l.frame = RectMake2x( 684-40, 0, 101, 140);
//        }
//        if (i == 4) {
//            l.frame = RectMake2x( 800-40, 0, 100, 140);
//        }
//        if (i == 5) {
//            l.frame = RectMake2x( 915-40, 0, 161, 140);
//        }
//        if (i == 6) {
//            l.frame = RectMake2x( 1031-40, 0, 160, 140);
//            l.numberOfLines = 0;
//
//        }
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 528, 140);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 568-40, 0, 116, 140);
        }
        
        if (i == 3) {
            l.frame = RectMake2x( 684-40, 0, 136, 140);
        }
        if (i == 4) {
            l.frame = RectMake2x( 800-40, 0, 115, 140);
        }
        if (i == 5) {
            l.frame = RectMake2x( 915-40, 0, 116, 140);
        }
        if (i == 6) {
            l.frame = RectMake2x( 1031-40, 0, 977, 140);
            //            l.numberOfLines = 0;

        }
        

        
        [cell.contentView addSubview:l];
    }
    
}

- (void)table3:(UITableViewCell *)cell{
    for (int i = 1; i < 3 ; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        l.tag = i +100;
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 980, 140);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 1024-40, 0, 984, 140);
        }
        
        [cell.contentView addSubview:l];
    }
    
}

- (void)table4:(UITableViewCell *)cell {
    for (int i = 1; i < 8 ; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        l.tag = i +100;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 385, 140);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 440-40, 0, 400, 140);
            l.numberOfLines = 0;

        }
        
        if (i == 3) {
            l.frame = RectMake2x( 840-40, 0, 399, 140);
        }
        if (i == 4) {
            l.frame = RectMake2x( 1239-40, 0, 192, 140);
        }
        if (i == 5) {
            l.frame = RectMake2x( 1431-40, 0, 192, 140);
        }
        if (i == 6) {
            l.frame = RectMake2x( 1623-40, 0, 192, 140);
        }
        if (i == 7) {
            l.frame = RectMake2x( 1815-40, 0, 192, 140);
        }
        
        [cell.contentView addSubview:l];
    }
}




- (UITableViewCell *)cell3Height
{
    
    static NSString *CellIdentifier = @"Cell3h";
    switch (currentTable ) {
        case 1:
            CellIdentifier = @"Cell1";
            break;
        case 2:
            CellIdentifier = @"Cell2";
            break;
        case 3:
            CellIdentifier = @"Cell3";
            break;
        case 4:
            CellIdentifier = @"Cell4";
            break;
        default:
            break;
    }

    UITableViewCell *cell = [tb dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[ImageView share] addToView:cell.contentView imagePathName:@"productlist_cell_bg" rect:RectMake2x(0, 0, 1900, 388)];
    
    
    switch (currentTable) {
        case 1:
            [self table1:cell];
            break;
        case 2:
            [self table2:cell];
            break;
        case 3:
            [self table4:cell];
            break;
        case 4:
            [self table4:cell];
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell3h";
    
    
    switch (currentTable ) {
        case 1:
            CellIdentifier = @"Cell1";
            break;
        case 2:
            CellIdentifier = @"Cell2";
            break;
        case 3:
            CellIdentifier = @"Cell3";
            break;
        case 4:
            CellIdentifier = @"Cell4";
            break;
        default:
            break;
    }
    
    
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
    UILabel *l5 = (UILabel *)[cell.contentView viewWithTag:105];
    UILabel *l6 = (UILabel *)[cell.contentView viewWithTag:106];
    UILabel *l7 = (UILabel *)[cell.contentView viewWithTag:107];
    UILabel *l8 = (UILabel *)[cell.contentView viewWithTag:108];
    
    
    
    l1.text = @"";
    l2.text = @"";
    l3.text = @"";
    l4.text = @"";
    
    l5.text = @"";
    l6.text = @"";
    l7.text = @"";
    l8.text = @"";
    

    
    switch (currentTable) {
        case 1:
        {
            l1.text = dict[@"MaId"][@"text"];
            l2.text = dict[@"MaDec"][@"text"];
            l3.text = dict[@"MaUnit"][@"text"];
            l4.text = dict[@"PlanNumber"][@"text"];
            l5.text = dict[@"SalePrice"][@"text"];
            l6.text = dict[@"Amount"][@"text"];
            l7.text = dict[@"Remark"][@"text"];


            
            break;
        }
        case 2:
        {
            l1.text = dict[@"Name"][@"text"];
            l2.text = dict[@"Unit"][@"text"];
            l3.text = dict[@"Price"][@"text"];
            l4.text = dict[@"Quantity"][@"text"];
            l5.text = dict[@"Money"][@"text"];
            l6.text = dict[@"Remark"][@"text"];

            break;
        }
        case 3:
        {
            l1.text = dict[@"Type"][@"text"];
            l2.text = dict[@"Info"][@"text"];
            l3.text = dict[@"SetName"][@"text"];
            l4.text = dict[@"SalePrice"][@"text"];
            l5.text = dict[@"Unit"][@"text"];
            l6.text = dict[@"Quantity"][@"text"];
            l7.text = dict[@"Money"][@"text"];
            
            break;
        }
        default:
            break;
    }
 

    return cell;
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


@end
