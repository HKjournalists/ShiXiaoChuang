//
//  ZHViewController.m
//  Designer
//
//  Created by bejoy on 14-3-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHViewController.h"
#import "AFNetworking.h"
#import "ProductCCell.h"
#import "CuiKuanCell.h"

#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "OpenUDID.h"
#import <AdSupport/AdSupport.h>
#import "XMLReader.h"
#import "LocationManager.h"

#import "ZHConstructionViewController.h"
#import "AFNetworking.h"


@interface ZHViewController ()
{
    UIView *launchView;
    UIView *mainView;
    
    UIView *menuView;
    UIView *contentView;
    UIImageView *iv;

    UIScrollView *sv;
    


    
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *dateLabel;
    
    
    UIScrollView *infoSV;
    UIImageView *designerImageView;
    
}


@end

@implementation ZHViewController


#pragma mark - openViewController

- (void)loginOut:(UIButton *)button
{
    
    NSString *currentUser = [Cookie getCookie:KCurrentUser];

    [Cookie setCookie:KCurrentUser value:nil];
    [Cookie setCookie:currentUser value:nil];
    ZHAppDelegate *appDelegate =  (ZHAppDelegate *)[[UIApplication sharedApplication] delegate] ;
    
    [appDelegate applicationDidBecomeActive:nil];

    
}



- (void)update
{
    [[Message share] messageAlert:@"您确定要退出吗？" delegate:self];
}



- (void)openViewController:(UIButton *)button
{

    if (currentButton != button && button.tag != 104) {
        currentButton = button;
        for (int i = 1; i< 7; i++) {
            
            UIButton *b =(UIButton *)[menuView viewWithTag:i];
            b.selected = NO;
        }
        button.selected = YES;
    }
    
    
    
    BaseViewController *bv;
    switch (button.tag ) {
        case 1:
        {
            bv = [[ZHConstructionViewController alloc] init];
            

            break;
        }
        case 2:
        {
            baseView.alpha = 1;

            break;
        }
        case 3:
        {

            baseView.alpha = 1;

            break;
        }
        case 104:
        {
            [self update];
            return;
            break;
        }
        default:
            break;
    }

    [self animationPush];
    
    bv.view.alpha  = 0;
    [self.view addSubview:bv.view];
    [self addChildViewController:bv]; 
    
    [UIView animateWithDuration:KMiddleDuration animations:^{
        bv.view.alpha  = 1;
    }];


    
}

- (void)openConstruction:(UIButton *)button
{
    if (currentButton != button) {
        currentButton = button;
        for (int i = 1; i< 9; i++) {
            
            UIButton *b =(UIButton *)[menuView viewWithTag:i];
            b.selected = NO;
        }
        button.selected = YES;
    }
    

    NSString *s = [NSString stringWithFormat:@"%d", button.tag -1];
    switch (button.tag) {
        case 1:
            s = @"0";

            break;
        case 2:
            s = @"1";
            break;
        case 3:
            s = @"DIS";
            break;
        case 4:
            s = @"HIDE";
            break;
        case 5:
            s = @"MID";
            break;
        case 6:
            s = @"END";
            break;
        case 7:
            s = @"GetConstructionsMoney";
            break;
        case 8:
            s = @"GetConstructionsWarn";
            break;

        default:
            break;
    }

    currentProcess = s;
    [self loadConstructionsData:@"0" type:s];


}


- (void)animationPull
{
    [UIView animateWithDuration:KMiddleDuration animations:^{
        
        menuView.frame = RectMake2x(0, 0, 350, 1536);
        contentView.frame = RectMake2x(350, 0, 1698, 1536 );
        
    }];
}
- (void)animationPush
{
    [UIView animateWithDuration:KMiddleDuration animations:^{
        
        menuView.frame = RectMake2x(-350, 0, 350, 1536);
        contentView.frame = RectMake2x(2048, 0, 1698, 1536 );
        
    }];
    
    
}
#pragma mark - Action
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1) {
        [self loginOut:nil];
    }
}


#pragma mark - b map



- (void)loadBaiduMapData
{
    _offlineMap = [[BMKOfflineMap alloc] init];
    _offlineMap.delegate = self;
   
    NSArray* records = [_offlineMap searchCity:@"北京"];
    oneRecord = [records objectAtIndex:0];
    [_offlineMap start:oneRecord.cityID];
    
    
    
}


//开始下载离线包
-(IBAction)start:(id)sender
{
    [_offlineMap start:oneRecord.cityID];
}
//停止下载离线包
-(IBAction)stop:(id)sender
{
    [_offlineMap pause:oneRecord.cityID];
}
//扫瞄离线包
-(IBAction)scan:(id)sender
{
    [_offlineMap scan:NO];
    
}
//删除本地离线包
-(IBAction)remove:(id)sender
{
    [_offlineMap remove:oneRecord.cityID];
    
}

#pragma mark -

- (void)putImage:(NSData *)data
{
    
    UIImage *image = [UIImage imageNamed:@"标题图-中期验收"];
    
    NSData *i_data =  UIImageJPEGRepresentation(image, .8);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/soap+xml"];
    
    NSString *strEncoded = [Base64 encode:i_data];
    
    NSDictionary *parameters = @{ @"ImgIn":  strEncoded};
    
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/PutImage", KHomeUrl];

    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *parseError = nil;
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSDictionary *dict = [XMLReader dictionaryForXMLString:s error:&parseError];
        dict = dict[@"OrderState"];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSError *parseError = nil;
//        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:operation.responseObject error:&parseError];
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    
}




- (void)showMenuView
{
    [UIView animateWithDuration:KMiddleDuration animations:^{
        menuView.frame = CGRectMake(0, 0, 55, 768);
    }];
}


- (void)scrollMain
{
    [sv scrollRectToVisible:screen_BOUNDS(1) animated:NO];
}

- (void)loadConstructionNum
{
    

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSDictionary *parameters = @{ @"monitorId":  SharedAppUser.ID
                                 };
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/GetConstructionsStateCount", KHomeUrl];

    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSError *parseError = nil;
        
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSDictionary *dict = [XMLReader dictionaryForXMLString:s error:&parseError];
        
        
        dict = dict[@"OrderState"];
        
        if (dict == nil) {
            [SVProgressHUD dismiss];
            
//            [[Message share] messageAlert:[NSString stringWithFormat:@"%@", s]];
            
            return ;
        }
        else {
            [SVProgressHUD dismiss];
            
            int all =  [dict[@"DisCheck"][@"text"] intValue]
                                + [dict[@"HideCheck"][@"text"] intValue]
                                + [dict[@"MidCheck"][@"text"] intValue]
                                +[dict[@"EndCheck"][@"text"] intValue];
            
            NSString *allString = [NSString stringWithFormat:@"%d", all ];
            
            for (int i = 1; i<9; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:i];
                
                UILabel *l1 = [[UILabel alloc] init];
                l1.frame = CGRectMake(133, 12, 25, 20);
                l1.backgroundColor = [UIColor orangeColor];
                l1.textColor = [UIColor whiteColor];
                l1.font = [UIFont systemFontOfSize:12];
                l1.textAlignment = NSTextAlignmentCenter;
                l1.layer.masksToBounds = YES;
                l1.layer.cornerRadius = 5;

                
                switch (i) {
                    case 1:
                        l1.text = allString;
                        break;
                    case 2:
                        l1.text = dict[@"TourCheck"][@"text"];
                        break;
                    case 3:
                        l1.text = dict[@"DisCheck"][@"text"];
                        break;
                    case 4:
                        l1.text = dict[@"HideCheck"][@"text"];
                        break;
                    case 5:
                        l1.text = dict[@"MidCheck"][@"text"];
                        break;
                    case 6:
                        l1.text = dict[@"EndCheck"][@"text"];
                        break;
                    case 7:
                        l1.text = dict[@"Payed"][@"text"];
                        break;
                    case 8:
                        l1.text = dict[@"Warn"][@"text"];
                        break;
                    default:
                        break;
                }
                
                [button addSubview:l1];
            }
            
        
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];

}

- (void)reloadConstructionsData
{

    SharedAppUser.ID = [Cookie getCookie:@"uuid"];

    [self loadConstructionNum];
    [self loadConstructionsData:@"0" type:currentProcess];
    
    nameLabel.text = SharedAppUser.account;

}


- (void)loadConstructionsData:(NSString *)currentPage type:(NSString *)type
{

    
    [self.dataMArray removeAllObjects];

    
//    if (self.dataMArray) {
//        self.dataMArray = nil;
//    }
    
    
//    更新工地内容
    
    [SVProgressHUD showWithStatus:@"正在刷新数据..." maskType:SVProgressHUDMaskTypeGradient];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSDictionary *parameters = @{ @"monitorId":  SharedAppUser.ID ,
                                  @"type": type,
                                  @"currentPage": currentPage};
    
//    NSString *urlStr = [NSString string];
    
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/", KHomeUrl];

    
    
    if ([type isEqualToString:@"GetConstructionsMoney"]) {
        [urlStr appendString:@"GetConstructionsMoney"];
//        urlStr = @"http://oa.sitrust.cn:8001/Tositrust.asmx/GetConstructionsMoney";

    }
    else if ( [type isEqualToString:@"GetConstructionsWarn"])
    {
        [urlStr appendString:@"GetConstructionsWarn"];

//        urlStr = @"http://oa.sitrust.cn:8001/Tositrust.asmx/GetConstructionsWarn";
    }
    else {
        [urlStr appendString:@"GetConstructions"];

//        urlStr = @"http://oa.sitrust.cn:8001/Tositrust.asmx/GetConstructions";
    }
    
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                
        NSError *parseError = nil;
        
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSDictionary *dict = [XMLReader dictionaryForXMLString:s error:&parseError];
        
        
        dict = dict[@"ArrayOfOrder"][@"Order"];
        
        if (dict == nil) {
            [SVProgressHUD dismiss];
            
//            [[Message share] messageAlert:[NSString stringWithFormat:@"%@", s]];
            self.dataMArray = [[NSMutableArray alloc] init];
            [_collectionView reloadData];

            return ;
        }
        else {
            [SVProgressHUD dismiss];


            
            if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                [self.dataMArray addObject:  dict];
            }
            else {
                self.dataMArray =  dict;
            }

            [_collectionView reloadData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"实小创-allbg"]];


    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350/2, 768)];
    menuView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"左菜单-allbg"]];
    
    

    contentView = [[UIView alloc] initWithFrame:RectMake2x(350, 0, 1698, 1536)];
    
    [[ImageView share] addToView:contentView imagePathName:@"标题图-所有工地" rect:RectMake2x(40, 82, 144, 33 )];

    nameLabel = [[UILabel alloc] initWithFrame:RectMake2x(18, 316, 300, 55)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:30];
    nameLabel.textColor = [[Theme share] giveColorfromStringColor:@"nameLabel"];
    [menuView addSubview:nameLabel];

    timeLabel = [[UILabel alloc] initWithFrame:RectMake2x(96, 396, 150, 55)];
    timeLabel.font = [UIFont systemFontOfSize:30];
    timeLabel.textColor = [[Theme share] giveColorfromStringColor:@"nameLabel"];
    [menuView addSubview:timeLabel];
    
    dateLabel = [[UILabel alloc] initWithFrame:RectMake2x(99, 456, 180, 55)];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = [[Theme share] giveColorfromStringColor:@"nameLabel"];
    [menuView addSubview:dateLabel];
    
    
    
    [self.view addSubview:contentView];
    [self.view addSubview:menuView];
    
//    UIButton *b = [[Button share] addToView:contentView addTarget:self rect:RectMake2x(100, 100, 300, 300) tag:1 action:@selector(openViewController:)];
//    b.backgroundColor = [UIColor blueColor];

    
    
    NSArray *array = @[@"按钮0-所有工地",@"按钮1-今日巡场", @"按钮2-待交底"  , @"按钮3-待隐蔽验收", @"按钮4-待中期验收", @"按钮5-待竣工验收", @"按钮6-催款工地", @"按钮7-预警工地"  ];
    
    NSArray *array1 = @[  @"按钮-注销"  ];
    
    
    int yHeight = 558/2;
    int y = 108/2;
    
    int i = 1;
    for (NSString *str in array ) {
        NSString *imgNormal = [NSString stringWithFormat:@"%@-00", str ];
        NSString *imgSelect = [NSString stringWithFormat:@"%@-01", str ];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, yHeight + (i-1)*y, 350/2, 88/2);
        button.tag = i;
        [button addTarget:self action:@selector(openConstruction:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imgSelect] forState:UIControlStateSelected];
        
        if (i == 2) {
            button.selected = YES;
            currentProcess = @"1";
        }
        [menuView addSubview:button];
        
        i ++;
    }
    
    
    int yH = 1386/2;
    
    int j = 1;
    for (NSString *str in array1 ) {
        NSString *imgNormal = [NSString stringWithFormat:@"%@-0", str ];
        NSString *imgSelect = [NSString stringWithFormat:@"%@-1", str ];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, yH + (j-1)*y, 350/2, 130/2);
        button.tag = 104;
        [button addTarget:self action:@selector(openViewController:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imgSelect] forState:UIControlStateHighlighted];
        
        [menuView addSubview:button];
        
        j ++;
    }
    

    
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _collectionView=[[UICollectionView alloc] initWithFrame:RectMakeC2x(40, 140, 1618, 1356) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.backgroundColor = [UIColor clearColor];
    
    UINib *nib = [UINib nibWithNibName:@"ProductCCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"ProductCCell"];
  
    UINib *nib1 = [UINib nibWithNibName:@"CuiKuanCell" bundle:nil];
    [_collectionView registerNib:nib1 forCellWithReuseIdentifier:@"CuiKuanCell"];

    
    [contentView addSubview:_collectionView];


    
}

- (void)loadData{
    
    
    _viewControllers = [[NSMutableArray alloc] init];
     self.dataMArray  = [[NSMutableArray alloc] init];
    currentProcess = @"1";
//    self.dataMArray = [[NSMutableArray alloc] init];

    
    

}


- (void)getUserProfileSuccess:(UIButton *)button
{

    nameLabel.text = SharedAppUser.account;

    [self animationPull];
}



- (void)currentDatetime
{
    NSDate *date = [Cookie getCookie:@"datetime"];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    
    [comp setSecond:1];
    
    NSDate *currentDateTime = [[NSCalendar currentCalendar]
                               dateByAddingComponents:comp toDate:date options:0];
    
    
    [Cookie setCookie:@"datetime" value:currentDateTime];

    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"HH:mm"];
	NSString *timeStr = [outputFormatter stringFromDate:currentDateTime];

    timeLabel.text = timeStr;

    
    
    [outputFormatter setDateFormat:@"yyyy/MM/dd"];
    
    
	NSString *dateStr = [outputFormatter stringFromDate:currentDateTime];

    
    

    dateLabel.text = dateStr;

}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadData];
    
    [[LocationManager share] setupLocationManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserProfileSuccess:) name:@"Notification_GetUserProfileSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadConstructionsData) name:@"reloadConstructionsData" object:nil];

    [self loadBaiduMapData];


    
    [self currentDatetime];

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(currentDatetime) userInfo:nil repeats:YES];

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (SharedAppUser.account  != nil) {
        [self reloadConstructionsData];
        nameLabel.text = SharedAppUser.account;


    }
    [self loadConstructionNum];

    _offlineMap.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放




}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - action

- (void)openProductDetail:(NSIndexPath *)indexPath
{
    
    
    
    int index = indexPath.row;

    
    BaseViewController *bv;
 
    bv = [[ZHConstructionViewController alloc] initWithNibName:@"ZHConstructionViewController" bundle:nil];
    bv.dataMDict = [self.dataMArray objectAtIndex:index];
    

    [self animationPush];
    
    bv.view.alpha  = 0;
    [self.view addSubview:bv.view];
    [self addChildViewController:bv];
    
    [UIView animateWithDuration:KMiddleDuration animations:^{
        bv.view.alpha  = 1;
    }];
    
    
    
    
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ( !   [currentProcess isEqualToString:@"GetConstructionsMoney"] ) {
        ProductCCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCCell" forIndexPath:indexPath];
        cell.type = 0;
        
        NSDictionary *dict = [self.dataMArray objectAtIndex:indexPath.row];
        cell.dict = dict;
        
        return cell;
    }
    else {
        CuiKuanCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CuiKuanCell" forIndexPath:indexPath];
        cell.type = 0;
        
        NSDictionary *dict = [self.dataMArray objectAtIndex:indexPath.row];

        cell.dict = dict;
        
        return cell;
    }

}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(535/2, 449/2);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self openProductDetail:indexPath];

}


@end
