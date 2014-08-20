//
//  ZHBaseMaterialsViewController.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-24.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHOrderChangeViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XMLReader.h"
#import "ZHChangeViewController.h"

@interface ZHOrderChangeViewController ()

@end

@implementation ZHOrderChangeViewController


- (void)getTable:(NSString *)string
{
    
    
    [self.dataMArray removeAllObjects];
    [tb reloadData];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/GetOrderChange"];
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/GetOrderChange", KHomeUrl];

//    NSDictionary *parameters = @{@"orderId": self.dataMDict[@"Id"][@"text"]};
  
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
            
            
            if ([dict[@"ArrayOfOrderChange"][@"OrderChange"] isKindOfClass:[NSMutableDictionary class]]) {
                self.dataMArray = [[NSMutableArray alloc] initWithObjects:dict[@"ArrayOfOrderChange"][@"OrderChange"], nil];
            }
            else {
                self.dataMArray = dict[@"ArrayOfOrderChange"][@"OrderChange"];

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

- (void)loadView
{
    [super loadView];
    
    
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
 
    
    
    [[ImageView share] addToView:self.view imagePathName:@"标题图-变更单" rect:RectMake2x(40, 80, 230, 40)];
    
    
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
    return 70;
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
    [[ImageView share] addToView:headerView imagePathName:@"表格-标题黄线" rect:CGRectMake(0, 44,1968/2, 1)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 1968/2, 44)];
    label.font = [UIFont boldSystemFontOfSize:25];
    
    [headerView addSubview:label];
    
    NSArray *header = @[@"变更类型", @"价格", @"日期"];
    

    for (int i = 1; i < 4; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 656, 90);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 656, 0, 656, 90);
        }
        
        if (i == 3) {
            l.frame = RectMake2x( 1312, 0, 656, 90);
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [[ImageView share] addToView:cell.contentView imagePathName:@"productlist_cell_bg" rect:RectMake2x(0, 0, 1900, 388)];
    
    
    for (int i = 1; i < 5 ; i++) {
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        l.tag = i +100;
        
        if ( i  ==1) {
            l.frame = RectMake2x( 10, 0, 656, 140);
            l.numberOfLines = 0;
        }
        if (i == 2) {
            l.frame = RectMake2x( 656, 0, 656, 140);
        }
        
        if (i == 3) {
            l.frame = RectMake2x( 1312, 0, 656, 140);
        }
        
//        if (i == 4) {
//            l.frame = RectMake2x( 1331, 0, 243, 90);
//        }
//        if (i == 5) {
//            l.frame = RectMake2x( 1574, 0, 394, 90);
//        }
        
        [cell.contentView addSubview:l];
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
    
    
    
    NSDictionary *dict =self.dataMArray [indexPath.row];
    
    UILabel *l1 = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *l2 = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *l3 = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *l4 = (UILabel *)[cell.contentView viewWithTag:104];
    
    
    l1.text = @"";
    l2.text = @"";
    l3.text = @"";
    l4.text = @"";
    
    l1.text = dict [@"Type"][@"text"];
    l2.text = dict [@"Money"][@"text"];
    l3.text = dict [@"ChangeDate"][@"text"];
    
 

    return cell;
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZHChangeViewController *bv = [[ZHChangeViewController alloc] init];
    
    bv.dataMDict = self.dataMArray[indexPath.row];
    bv.view.alpha  = 0;
    [self.view addSubview:bv.view];
    [self addChildViewController:bv];
    
    [UIView animateWithDuration:KMiddleDuration animations:^{
        bv.view.alpha  = 1;
    }];
    
}


@end
