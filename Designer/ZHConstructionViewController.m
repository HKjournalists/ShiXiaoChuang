//
//  ZHConstructionViewController.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-17.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHConstructionViewController.h"
#import "ZHChangeOrderListViewController.h"
#import "AFNetworking.h"
#import "BMKAnnotation.h"
#import "SVProgressHUD.h"
#import "XMLReader.h"
#import "LocationManager.h"
#import "ZHBaseMaterialsViewController.h"
#import "ZHMainMaterialsViewController.h"
#import "ZHFinesViewController.h"
#import "ZHDelayViewController.h"
#import "ZHOrderChangeViewController.h"
#import "ZHTmpeViewController.h"
#import "WKKViewController.h"
#import "ZHLicenseViewController.h"
#import "ZHBiShuiCheckViewController.h"


#define Kdescription_1 @"待交底"
#define Kdescription_2 @"待隐蔽验收"
#define Kdescription_3 @"待中期验收"
#define Kdescription_4 @"待竣工验收"


#define Kdescription_5 @"竣工验收成功"
#define Kdescription_6 @"确认竣工"



@interface ZHConstructionViewController ()
{
    UIView *menuView;
    UIView *contentView;

    UIScrollView *sv;
    
    
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *dateLabel;
    
}

@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSNumber *damping;
@property (strong, nonatomic) NSNumber *velocity;

@end

@implementation ZHConstructionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)animationPush
{
    [UIView animateWithDuration:KMiddleDuration animations:^{
        
        menuView.frame = RectMake2x(0, 0, 350, 1536);
        contentView.frame = RectMake2x(350, 0, 1698, 1536 );
        
    }];
}

- (void)animationPull
{
    [UIView animateWithDuration:KMiddleDuration animations:^{
        
        menuView.frame = RectMake2x(-350, 0, 350, 1536);
        contentView.frame = RectMake2x(2048, 0, 1698, 1536 );
    } completion:^(BOOL finished) {
        if (finished) {
            [self back:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_GetUserProfileSuccess" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadConstructionsData" object:nil];
            
        }
    }];
}

- (void)loadAnimotion
{
//    [self animationPush];
    
    //Animate using values from sliders and segementedControl
    [UIView animateWithDuration:[self.duration floatValue] delay:0 usingSpringWithDamping:[self.damping floatValue] initialSpringVelocity:[self.velocity floatValue] options:UIViewAnimationOptionCurveLinear animations:^{
        
        menuView.frame = RectMake2x(0, 0, 350, 1536);
        contentView.frame = RectMake2x(350, 0, 1698, 1536 );
    } completion:^(BOOL finished) {
    }];
    
    
}



- (void)pullView
{
    

    [self animationPull];

}


- (void)openViewController:(UIButton *)button
{

    for (int i = 1; i< 7; i++) {
        UIButton *b =(UIButton *)[menuView viewWithTag:i];
        b.selected = NO;
    }
    button.selected = YES;

    [sv scrollRectToVisible:RectMake2x(0, (button.tag-1) * 1536, 1698, 1536 ) animated:YES];
    if (button.tag == 1) {
        return;
    }
    
    
    tbBaseView.frame = RectMake2x(0, (button.tag-1) * 1536, 1698, 1536 );

    [UIView animateWithDuration:KMiddleDuration animations:^{
        tb.alpha = 0;

    }completion:^(BOOL finished) {

        if (finished) {

            [UIView animateWithDuration:KDuration animations:^{
                
                tb.alpha = 1;
            }];
        }
    }];
    
    NSString *table ;
    
    switch (button.tag ) {
        case 2:
        {
            currentProcess = 1;
            table = @"交底验收单";
            break;
        }
        case 3:
        {
            currentProcess = 2;
            table = @"隐蔽验收单";
            break;
        }
        case 4:
        {
            currentProcess = 3;
            table = @"中期验收单";
            break;
        }
        case 5:
        {
            currentProcess = 4;
            table = @"竣工验收单";
            break;
        }

        default:
            break;
    }
    
    [self getTable:table];
    
}

- (void)openListView:(UIButton *)button
{
    PdfPopoverController *pdfVC = [[PdfPopoverController alloc] init];
    
    _popover = [[UIPopoverController alloc] initWithContentViewController:pdfVC];
    pdfVC.popController = _popover;
    pdfVC.delegate= self;
    
    if (iOS7) {
        _popover.popoverContentSize = CGSizeMake(220, 445);
        _popover.backgroundColor = [UIColor clearColor];
    }

    [_popover presentPopoverFromRect:button.bounds inView:button
            permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

#pragma mark - popover

- (void)selectPopover:(NSIndexPath *)index
{
    
    BaseViewController *bv = nil;
    
    switch (index.section) {
        case 0:
        {
            switch (index.row) {
                case 0:
                {
                    bv = [[ZHBaseMaterialsViewController alloc] init];
                    break;
                }
                case 1:
                {
                    bv = [[ZHMainMaterialsViewController alloc] init];
                    
                    break;
                }
                case 2:
                {
                    bv = [[ZHOrderChangeViewController alloc] init];
                    
                    break;
                }

                default:
                    break;
            }
            break;
        }
        case 1:
        {
            
            switch (index.row) {
                case 0:
                {
                    bv = [[ZHBiShuiCheckViewController alloc] init];
                    break;
                }
                case 1:
                {
                    bv = [[ZHLicenseViewController alloc] init];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            
            switch (index.row) {
                case 0:
                {
                    
                    bv = [[ZHTmpeViewController alloc] initWithNibName:@"ZHTmpeViewController" bundle:nil];
                    
                    break;
                }
                case 1:
                {
                    
                    bv = [[ZHDelayViewController alloc] initWithNibName:@"ZHDelayViewController" bundle:nil];
                    
                    break;
                }
                case 2:
                {
                    
                    bv = [[ZHFinesViewController alloc] initWithNibName:@"ZHFinesViewController" bundle:nil];
                    
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    
    
    bv.dataMDict = self.dataMDict;
    bv.view.alpha  = 0;
    [self.view addSubview:bv.view];
    [self addChildViewController:bv];
    
    [UIView animateWithDuration:KMiddleDuration animations:^{
        bv.view.alpha  = 1;
    }];

}


#pragma mark -

- (void)loadView
{
    [super loadView];
    
    SharedAppUser.ID = [Cookie getCookie:@"uuid"];
    
    menuView = [[UIView alloc] initWithFrame:CGRectMake(-350, 0, 350/2, 768)];
    menuView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"左菜单-allbg-1"]];
    
    nameLabel = [[UILabel alloc] initWithFrame:RectMake2x(18, 316, 300, 55)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:30];
    nameLabel.textColor = [[Theme share] giveColorfromStringColor:@"nameLabel"];
    nameLabel.text = SharedAppUser.account;
    [menuView addSubview:nameLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:RectMake2x(96, 396, 150, 55)];
    timeLabel.font = [UIFont systemFontOfSize:30];
    timeLabel.textColor = [[Theme share] giveColorfromStringColor:@"nameLabel"];
    [menuView addSubview:timeLabel];
    
    dateLabel = [[UILabel alloc] initWithFrame:RectMake2x(99, 456, 180, 55)];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = [[Theme share] giveColorfromStringColor:@"nameLabel"];
    [menuView addSubview:dateLabel];
    
    
    
    
    contentView = [[UIView alloc] initWithFrame:RectMake2x(2048, 0, 1698, 1536)];
    contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"菜单条"]];
    contentView.backgroundColor = [ UIColor clearColor];
    
    
    [self.view addSubview:contentView];
    [self.view addSubview:menuView];
    
    
    [[Button share] addToView:menuView addTarget:self rect:CGRectMake(0, 768-90, 350/2, 90) tag:1 action:@selector(pullView)];
    
    

     NSArray *array = @[@"按钮1--工地信息",@"按钮2--现场交底", @"按钮3--隐蔽验收单", @"按钮3--中期验收单", @"按钮4--竣工验收单"  ];
     
//     NSArray *array1 = @[  @"按钮-注销"  ];
    

     
     int yHeight = 545/2;
     int y = 174/2;
     
     int i = 1;
     for (NSString *str in array ) {
         NSString *imgNormal = [NSString stringWithFormat:@"%@-00", str ];
         NSString *imgSelect = [NSString stringWithFormat:@"%@-01", str ];
         
         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
         button.frame = CGRectMake(28/2, yHeight + (i-1)*y, 294/2, 160/2);
         button.tag = i;
         [button addTarget:self action:@selector(openViewController:) forControlEvents:UIControlEventTouchUpInside];
         [button setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
         [button setImage:[UIImage imageNamed:imgSelect] forState:UIControlStateSelected];
         
         
         
         if (i == 1) {
             button.selected = YES;
         }
         [menuView addSubview:button];
         
         i ++;
     }
    
    
    
    sv = [[UIScrollView alloc] initWithFrame:RectMake2x(0, 0, 1698, 1536)];
    sv.pagingEnabled = YES;
    sv.scrollEnabled = NO;
    [sv setContentSize:CGSizeMake(1698/2, 768*6)];
    [contentView addSubview:sv];
    
    
    int h = 1536;
    
    for (int i = 0; i <=5; i ++) {
        UIView *v1 = [[UIView alloc] initWithFrame:RectMake2x(0, i*h, 1698, 1536)];
        if (i == 0) {
            [v1 addSubview:_constructinoView];
        }
        
        [sv addSubview:v1];
    }
    
    
    
    [[Button share] addToView:self.view addTarget:self rect:RectMake2x(1942, 61, 71, 63) tag:100 action:@selector(openListView:) imagePath:@"按钮-附加菜单-01" highlightedImagePath:@"按钮-附加菜单-00"];
    
    
    [[ImageView share] addToView:sv imagePathName:@"标题图-现场交底" rect:RectMake2x(40, 80+1536, 230, 40)];
    [[ImageView share] addToView:sv imagePathName:@"标题图-隐蔽验收" rect:RectMake2x(40, 80+1536*2, 230, 40)];
    [[ImageView share] addToView:sv imagePathName:@"标题图-中期验收" rect:RectMake2x(40, 80+1536*3, 230, 40)];
    [[ImageView share] addToView:sv imagePathName:@"标题图-竣工验收" rect:RectMake2x(40, 80+1536*4, 230, 40)];
    
    
    tbBaseView = [[UIView alloc] initWithFrame:RectMake2x(0 , 1536, 1858, 1536)];
    tb = [[UITableView alloc] initWithFrame:RectMake2x(40 , 162, 1618, 1396) style:UITableViewStylePlain];
    tb.backgroundColor = [UIColor clearColor];
    
    tb.dataSource = self;
    tb.delegate = self;
    
    [tbBaseView addSubview:tb];
    [sv addSubview:tbBaseView];
    
    
    
    
//    [[Button share] addToView:self.view addTarget:self rect:RectMake2x(1802, 61, 71, 63) tag:100 action:@selector(openUploadImageView:) imagePath:@"按钮-附加菜单-01" highlightedImagePath:@"按钮-附加菜单-00"];
    
}


- (void)openCamera:(UIButton *)button
{
    

    BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

    if (isCameraSupport) {
        WKKViewController *kVC = [[WKKViewController alloc] initWithNibName:@"WKKViewController" bundle:nil];
        kVC.dataMDict = self.dataMDict;
        [self.view addSubview:kVC.view];
        [self addChildViewController:kVC];
    }
    else {
        [[Message share] messageAlert:@"该设备不支持拍照"];
    }
    

}
- (void)openUploadImageView:(UIButton *)button
{
    
    UIView *uploadView = [[UIView alloc] initWithFrame:self.view.frame];
    UIView *uploadBackgoundView = [[UIView alloc] initWithFrame:self.view.frame];
    uploadBackgoundView.backgroundColor = [UIColor blackColor];
    uploadBackgoundView.alpha = .9;
    
    [uploadView addSubview:uploadBackgoundView];
    [self.view addSubview:uploadView];
    
    
    
    
    [[Button share] addToView:uploadView addTarget:self rect:RectMake2x(1802, 61, 71, 63) tag:100 action:@selector(openCamera:) imagePath:@"按钮-附加菜单-01" highlightedImagePath:@"按钮-附加菜单-00"];
    
    
}




- (void)reloadFinesAndDelay
{
    [infoArray removeAllObjects];
    infoArray = [[NSMutableArray alloc] init];
    [self getGetDelayInfo];
}

- (void)loadData
{
    
    self.dataMArray = [[NSMutableArray alloc] init];
    
    infoArray  = [[NSMutableArray alloc] init];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    [self loadData];
    // Set the parameters to be passed into the animation
    self.duration = [NSNumber numberWithFloat:.9];
    self.damping = [NSNumber numberWithFloat:.5];
    self.velocity = [NSNumber numberWithFloat:.4];
    
    
    [self startFollowing];
    
    [self currentDatetime];
    [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(currentDatetime) userInfo:nil repeats:YES];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFinesAndDelay) name:@"reloadFinesAndDelay" object:nil];

    
    
    _baidu_MapView.delegate = self;



    
}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
//    SharedAppUser.Lat = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
//    SharedAppUser.Lng = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
    
}



- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    SharedAppUser.Lat = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
    SharedAppUser.Lng = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
    

//    DLog(@"%f:%f",  userLocation.location.coordinate.latitude,  userLocation.location.coordinate.longitude );
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}



- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    
}





//跟随态
-(void)startFollowing
{
    NSLog(@"进入跟随态");

    _baidu_MapView.showsUserLocation = NO;
    _baidu_MapView.userTrackingMode = BMKUserTrackingModeNone;
    _baidu_MapView.showsUserLocation = YES;
    

}




- (void)loadConstructionInfo
{
    _construc_TypeLabel.text = self.dataMDict[@"Description"][@"text"];
    _coustomer_nameLabel.text = self.dataMDict[@"CustomerName"][@"text"];
    _coustomer_phone.text = self.dataMDict[@"CustomerPhone"][@"text"];
    _adreeLable.text = self.dataMDict[@"Address"][@"text"];
    _foremanNameLabel.text = self.dataMDict[@"ForemanName"][@"text"];
    _foreman_phoneLabel.text = self.dataMDict[@"ForemanPhone"][@"text"];
    _designer_nameLabel.text = self.dataMDict[@"DesignerName"][@"text"];
    _designer_phoneLabel.text = self.dataMDict[@"DesignerPhone"][@"text"];
    NSString *string = [NSString stringWithFormat:@"套餐:%@  签单额:%@  合同号：%@"
                        ,self.dataMDict[@"SetMealName"][@"text"]
                        , self.dataMDict[@"OrigCount"][@"text"]
                        , self.dataMDict[@"PactNumer"][@"text"]];
    
    _packNumLabel.text = string;

    NSMutableString *str = [NSMutableString string];
    
    if ([ self.dataMDict[@"DoorState"][@"text"] isEqualToString:@"1"]) {
        [str appendString:@"门精量已完成"];
    }
    else {
//        [str appendString:@"门没有精量"];
    }
    [str appendString:@" "];
    if ([ self.dataMDict[@"CupboardState"][@"text"] isEqualToString:@"1"]) {
        [str appendString:@"橱柜精量已完成"];
    }
    else {
//        [str appendString:@"橱柜没有精量"];
    }
    
    
    
    _jingliangStataLabel.text = str;
    double latitude = [self.dataMDict[@"Lat"][@"text"] doubleValue];
    double longitude = [self.dataMDict[@"Lng"][@"text"] doubleValue];
    
    
    NSLog(@"%f, %f", latitude, longitude);

    
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;

    if (latitude != 0 && latitude < 360) {
        coor.latitude = longitude;
        coor.longitude = latitude;
        _baidu_MapView.zoomLevel = 16;

    }
    else {
        coor.latitude = 39.9139;
        coor.longitude = 116.3917;
        _baidu_MapView.zoomLevel = 10;

    }
    annotation.coordinate = coor;
    _baidu_MapView.centerCoordinate = coor;

    annotation.title = self.dataMDict[@"Address"][@"text"];
    [_baidu_MapView addAnnotation:annotation];
    

    
}


- (void)loadDateView {
    for (int i =2; i < 6; i++) {
        
        UIButton *b = (UIButton *)[self.view viewWithTag:i];
        
        NSString * path = @"大五角星-未完成";
        
        if ( process >= 1 && i== 2) {
            path = @"大五角星-完成";
        }
        if (process  >= 2 && i == 3) {
            path = @"大五角星-完成";
        }
        if (process  >= 3 && i ==4) {
            path = @"大五角星-完成";
        }
        if (process  >= 4  && i ==5) {
            path = @"大五角星-完成";
        }
        
        [[ImageView share] addToView:b imagePathName:path rect:RectMake2x(14, 16, 75, 70)];
        
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:RectMake2x(115, 14, 164, 27)];
        UILabel *lab2 = [[UILabel alloc] initWithFrame:RectMake2x(115, 65, 164, 27)];
        
        lab1.textColor = [UIColor grayColor];
        lab2.textColor = [UIColor grayColor];
        [lab1 setFont:[UIFont systemFontOfSize:9]];
        [lab2 setFont:[UIFont systemFontOfSize:9]];
        
        
        switch ( i ) {
            case 2:
            {
                lab1.text = self.dataMDict[@"PlanDisDate"][@"text"];
                lab2.text = self.dataMDict[@"DisDate"][@"text"];
                break;
            }
            case 3:
            {
                lab1.text = self.dataMDict[@"PlanHideDate"][@"text"];
                lab2.text = self.dataMDict[@"HideDate"][@"text"];
                break;
            }
            case 4:
            {
                lab1.text = self.dataMDict[@"PlanMidDate"][@"text"];
                lab2.text = self.dataMDict[@"MidDate"][@"text"];
                break;
            }
            case 5:
            {
                lab1.text = self.dataMDict[@"PlanEndDate"][@"text"];
                lab2.text = self.dataMDict[@"EndDate"][@"text"];
                break;
            }
            default:
                break;
            
        }

        [b addSubview:lab1];
        [b addSubview:lab2];
        
    }
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadAnimotion];
    [self loadConstructionInfo];
    
    SharedAppUser.currentConstruction = self.dataMDict[@"Id"][@"text"];

    
    SharedAppUser.isSignalIn = NO;
//    process
    
    
    
    if ([self.dataMDict[@"Description"][@"text"] isEqualToString:Kdescription_1]) {
        process = 1;
    }
    if ([self.dataMDict[@"Description"][@"text"] isEqualToString:Kdescription_2]) {
        process = 2;
    }
    if ([self.dataMDict[@"Description"][@"text"] isEqualToString:Kdescription_3]) {
        process = 3;
    }
    if ([self.dataMDict[@"Description"][@"text"] isEqualToString:Kdescription_4]) {
        process = 4;
    }
    
    if ([self.dataMDict[@"Description"][@"text"] isEqualToString:Kdescription_5]) {
        process = 5;
    }
    if ([self.dataMDict[@"Description"][@"text"] isEqualToString:Kdescription_6]) {
        process = 5;
    }
    
    
    
    for (int i =2; i < 6; i++) {
        
        UIButton *b = (UIButton *)[self.view viewWithTag:i];
        
        NSString * path = @"大五角星-未完成";
        
        if ( process >= 1 && i== 2) {
            path = @"大五角星-完成";
        }
        if (process  >= 2 && i == 3) {
            path = @"大五角星-完成";
        }
        if (process  >= 3 && i ==4) {
            path = @"大五角星-完成";
        }
        if (process  >= 4  && i ==5) {
            path = @"大五角星-完成";
        }
        
        [[ImageView share] addToView:b imagePathName:path rect:RectMake2x(14, 16, 75, 70)];
    }

    
    
    
    
    
    NSDictionary *dict = [Cookie getCookie:SharedAppUser.currentConstruction];
    if ( ! dict) {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    [Cookie setCookie:SharedAppUser.currentConstruction value:dict];
    
    
    NSString *outString = [NSString stringWithFormat:@"out%@", [NSDate stringFromDate:[Cookie getCookie:@"datetime"] withFormat:@"yyyy-MM-dd"]];
    NSString *sinString =[NSString stringWithFormat:@"sin%@", [NSDate stringFromDate:[Cookie getCookie:@"datetime"] withFormat:@"yyyy-MM-dd"]];
    
    if ([dict[sinString] isEqualToString:@"1"]) {
        SharedAppUser.isSignalIn  = YES;
        _sinButton.selected = YES;
    }
    
    if ([dict[outString] isEqualToString:@"1"]) {
        _outButton.selected = YES;
        SharedAppUser.isSignalOut = YES;
    }
    
    

 
    [self getGetDelayInfo];
    
    
    
    
    
    
    [self checkLocationServicesEnabled:nil];
    

    
    [self loadDateView];
    
    
    
    double lat = [[Cookie getCookie:@"Lat"] doubleValue];
    double lng = [[Cookie getCookie:@"Lng"] doubleValue];
    
    CLLocationCoordinate2D point = CLLocationCoordinate2DMake(lat, lng);
    
    
    [_baidu_MapView setCenterCoordinate:point];
}

- (void)checkLocationServicesEnabled:(UIButton *)button
{
    
    if (button) {
        [button removeFromSuperview];
    }
    
    if ( [[LocationManager share] getLocationServicesEnabled]) {
        
    }
    else {
        
        
        [[Message share] messageAlert:@"请打开定位服务，并且选择始终允许访问位置信息， 否则您将无法做任何操作"];
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [b setTitle:@"请打开定位服务，并且选择始终允许访问位置信息， 否则您将无法做任何操作" forState:UIControlStateNormal];
        [b addTarget:self action:@selector(checkLocationServicesEnabled:) forControlEvents:UIControlEventTouchUpInside];
        b.frame = self.view.frame;
        
        [self.view addSubview:b];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    _baidu_MapView.delegate = nil;
    SharedAppUser.currentConstruction = @"";
    SharedAppUser.isSignalIn  = NO;
    SharedAppUser.isSignalOut = NO;

    
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    [outputFormatter setDateFormat:@"yyyy/MM/dd"];
    
    
	NSString *dateStr = [outputFormatter stringFromDate:currentDateTime];
    
    
//    
    timeLabel.text = timeStr;
    
    dateLabel.text = dateStr;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - data

- (void)dataToArray:(NSArray *)array
{
    
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    
    //    获取分类的信息

    for (NSDictionary *dict in array) {

        NSString *CheckType = dict[@"CheckType"][@"text"];
        
        [d setValue:CheckType forKey:CheckType];
    }
    
    
    for (NSString *s in d.allValues) {
        NSMutableArray *ma = [[NSMutableArray alloc] init];

        for (NSDictionary *item in array) {
            
            if ([item[@"CheckType"][@"text"] isEqualToString:s]) {
                
                //    按照分类创建数组
                [ma addObject:item];
            }
            
            
        }
        
        //    将arr 加入 dataMarray
        [self.dataMArray addObject:ma];
    }
    
    
    
    
    
    
}

#pragma mark - alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1) {
        
        
        if (isSingnal) {
            [self signalIntype:YES];

        }
        else {
            [self signalIntype:NO];

        }
        
    }
}

#pragma mark - network



- (void)putImage:(NSData *)data
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    UIImage *i = [UIImage imageNamed:@"按钮-材料变更单-1"];
    NSData *d = UIImageJPEGRepresentation(i, 1);
    NSString *string = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    
    
    NSDictionary *parameters = @{ @"ImgIn":  string
                                  };
    NSString *url = [NSString stringWithFormat:@"%@Tositrust.asmx/PutImage", KHomeUrl];

    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSError *parseError = nil;
        
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSDictionary *dict = [XMLReader dictionaryForXMLString:s error:&parseError];
        
        
        dict = dict[@"OrderState"];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    
}



- (void)getGetDelayInfo
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/GetDelay"];
    NSString *url = [NSString stringWithFormat:@"%@Tositrust.asmx/GetDelay", KHomeUrl];

    NSDictionary *parameters = @{@"orderId": self.dataMDict[@"Id"][@"text"]};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSError *parseError = nil;
        
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSDictionary *dict = [XMLReader dictionaryForXMLString:s error:&parseError];
        
        if (dict == nil) {
//            [SVProgressHUD dismiss];
            
            [infoArray addObject:  [[NSMutableArray alloc] initWithObjects: @{@"reason": @{@"text": @"暂无信息"}}, nil]];

            
            [self getFinesInfo];

            return ;
        }
        else {
            
            
            

            
            
            if ([dict[@"Delay"][@"Delay"] isKindOfClass:[NSMutableDictionary class]]) {

                
                [infoArray  addObject: [NSArray arrayWithObject:dict[@"Delay"][@"Delay"]]];
                
            }
            else {
                [infoArray addObject: dict[@"Delay"][@"Delay"] ];
            }
            
            

        
            [self getFinesInfo];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    
}

- (void)getFinesInfo
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/GetFines"];
    NSString *url = [NSString stringWithFormat:@"%@Tositrust.asmx/GetFines", KHomeUrl];

    NSDictionary *parameters = @{@"orderid": self.dataMDict[@"Id"][@"text"]};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSError *parseError = nil;
        
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSDictionary *dict = [XMLReader dictionaryForXMLString:s error:&parseError];
        dict = dict[@"ArrayOfFine"][@"Fine"];

        
        if (dict == nil) {
            
            [infoArray addObject:  [[NSMutableArray alloc] initWithObjects: @{@"Reason": @{@"text": @"暂无信息"}}, nil]];


        }
        else {
            
            
            if ( dict.count != 0  ) {
                
                if (  [dict isKindOfClass:[NSMutableDictionary class]] ) {

                    [infoArray addObject:[[NSMutableArray alloc] initWithObjects: dict, nil]];
                }
                else {
                    [infoArray addObject:dict];
                }
            }

            
            
            
            
        }
        
        
        [infotable reloadData];

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

    
    
    
//    NSString *url = [NSString stringWithFormat:@"http://oa.sitrust.cn:8001/Tositrust.asmx/GetTables"];
    NSString *url = [NSString stringWithFormat:@"%@Tositrust.asmx/GetTables", KHomeUrl];

    NSDictionary *parameters = @{@"tableName": string,
                                 @"orderId": self.dataMDict[@"Id"][@"text"]};
    
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

            

            [self dataToArray:dict[@"ArrayOfAPPCheckProject"][@"APPCheckProject"]];
            
            

            
            
            
            [tb reloadData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    
    

}



- (void)signalIntype:(BOOL)isSignalin{
    
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
 
    
    
    NSString *type = [NSString string];
    
    NSString *url = [NSString string];
    if (isSignalin) {
//        url = @"http://oa.sitrust.cn:8001/Tositrust.asmx/addSignalIN";
        url = [NSString stringWithFormat:@"%@Tositrust.asmx/addSignalIN", KHomeUrl];

        type =  @"signal in";
    }
    else {
//        url = @"http://oa.sitrust.cn:8001/Tositrust.asmx/addSignalOut";
        url = [NSString stringWithFormat:@"%@Tositrust.asmx/addSignalOut", KHomeUrl];

        type =  @"signal out";
    }
    
    
    NSDictionary *parameters = @{@"pactnumber": self.dataMDict[@"PactNumer"][@"text"],
                                 @"signalType": type,
                                 @"signalDate": [Cookie getCookie:@"datetime"],
                                 @"stuffCode": SharedAppUser.ID ,
                                 @"stuffName": SharedAppUser.account,
                                 @"longitudeX": SharedAppUser.Lat,
                                 @"longitudeY": SharedAppUser.Lng};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSError *parseError = nil;
        
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        
        bool b = [xmlDictionary[@"boolean"] objectForKey:@"text"];
        
        
        if ( ! b ) {
            [SVProgressHUD dismiss];

            [[Message share] messageAlert:[NSString stringWithFormat:@"%i", b]];
            
            return ;
        }
        else {

            currentButton.selected = YES;
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[Cookie getCookie:SharedAppUser.currentConstruction]];
            
            if ( ! dict) {
                dict = [[NSMutableDictionary alloc] init];
            }
            
            
            
            //


            
            if (isSignalin) {
                
                NSString *sinString =[NSString stringWithFormat:@"sin%@", [NSDate stringFromDate:[Cookie getCookie:@"datetime"] withFormat:@"yyyy-MM-dd"]];
                [dict setValue:@"1" forKey:sinString];
                SharedAppUser.isSignalIn = YES;

            }
            else {
                
                NSString *outString = [NSString stringWithFormat:@"out%@", [NSDate stringFromDate:[Cookie getCookie:@"datetime"] withFormat:@"yyyy-MM-dd"]];
                [dict setValue:@"1" forKey:outString];
                SharedAppUser.isSignalOut = YES;

            }
            
            [Cookie setCookie:SharedAppUser.currentConstruction value:dict];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
}








- (IBAction)addSignalIN:(id)sender {
    
    
    UIButton *button = (UIButton *)sender;
    
    
    if (button.selected == YES) {
        [[Message share] messageAlert:@"您已经签过到了，如果要签出请点击下面的签出按钮"];
        return;
    }
    currentButton = sender;
    isSingnal = YES;
    [[Message share] messageAlert:@"您确定要签入吗？" delegate:self];

    
}

- (IBAction)addSignalOut:(id)sender {
    
    if (SharedAppUser.isSignalIn == NO) {
        return  ;
    }
    
    UIButton *button = (UIButton *)sender;
    
    
    if (button.selected == YES) {
        [[Message share] messageAlert:@"您已经签出过了。"];

        return;
    }
    
    currentButton = sender;
    isSingnal = NO;
    [[Message share] messageAlert:@"您确定要签出吗？" delegate:self];
}







- (void)submitTable:(UIButton *)button
{
    
    [SVProgressHUD showWithStatus:@"正在提交数据..." maskType:SVProgressHUDMaskTypeGradient];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
    
    
//    url = [NSString stringWithFormat:@"%@Tositrust.asmx/addSignalOut", KHomeUrl];

    NSMutableString *url = [NSMutableString stringWithFormat:@"%@Tositrust.asmx/", KHomeUrl];
 
    switch (currentProcess) {
        case 1:
        {
            [url appendString:@"DisCheck"];
            break;
        }
        case 2:
        {
            [url appendString:@"HideCheck"];
            break;
        }
        case 3:
        {
            [url appendString:@"MidCheck"];
            break;
        }
        case 4:
        {
            [url appendString:@"EndCheck"];
            break;
        }
        default:
            break;
    }
    
   
    NSDictionary *parameters = @{@"orderId": self.dataMDict[@"Id"][@"text"],
                                 @"monitorId": SharedAppUser.ID ,
                                 @"monitorName": SharedAppUser.account ,
                                 @"lng":  SharedAppUser.Lng ,
                                 @"lat":  SharedAppUser.Lat } ;
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSError *parseError = nil;
        
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        
        NSString * b = [xmlDictionary[@"string"] objectForKey:@"text"];
       

        
        
        if (  [b isEqualToString:@"验收成功"]) {
            [SVProgressHUD dismiss];
                        button.enabled = NO;
            [[Message share] messageAlert:[NSString stringWithFormat:@"验收成功"]];
            
            
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[Cookie getCookie:SharedAppUser.currentConstruction]];
            
            NSString *table = [NSString stringWithFormat:@"table%d", currentProcess];
            [dict setValue:@"1" forKey:table];
            [Cookie setCookie:SharedAppUser.currentConstruction value:dict];
            
//            竣工
            
            if ( currentProcess == 4) {

                currentButton = self.outButton;
                [self signalIntype:NO];
            }
            
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


#pragma mark - action



- (void)selectItem:(UIButton *)button
{
    UITableViewCell * cell = (UITableViewCell *)[[[button superview]  superview] superview];

    if (iOS8) {
        
        cell = (UITableViewCell *)[[button superview]  superview];
    }
    NSIndexPath *indexPath = [tb indexPathForCell:cell];


    if (button.tag == 10908) {
//        type
//
        NSDictionary *indexDict = self.dataMArray[indexPath.section][indexPath.row];

        WKKViewController *kvc = [[WKKViewController alloc] initWithNibName:@"WKKViewController" bundle:nil];
        kvc.type =  currentProcess + 3;
        kvc.orderID = self.dataMDict[@"Id"][@"text"];
        kvc.itemId = indexDict[@"Id"][@"text"];
        
        [self.view addSubview:kvc.view];
        [self addChildViewController:kvc];
        
    }
    else {
        button.selected = YES;
        NSMutableDictionary *dict =  [Cookie getCookie:SharedAppUser.currentConstruction];

        if ( ! dict ) {
            dict  = [[NSMutableDictionary alloc] init];
        }
        dict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        
        
        

        
        NSDictionary *indexDict = self.dataMArray[indexPath.section][indexPath.row];
        
        
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
}

- (void)openProductDetail:(UIButton *)button
{
    
    UITableViewCell *cell = (UITableViewCell *)[[[button superview]  superview] superview];
    
    
    if (iOS8) {
        
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
    
    if (infotable == tableView) {
        if (infoArray.count ==1) {
            return 1;
        }
        return 2;
    }
    return self.dataMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (infotable == tableView) {
        
        if (infoArray.count != 0) {
            
            NSMutableArray *a =infoArray[section];
            return a.count;
        }
        else {
            return 0;
        }
        
    }
    NSArray *a = self.dataMArray[section];
    return a.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (infotable == tableView) {
        return 44;
    }
    return 56;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (infotable == tableView) {

        if (section == 0 )  {
            
            if ( infoArray.count != 0 ) {
                NSDictionary *d = infoArray[section][0];

                if ( [d[@"reason"][@"text"] isEqualToString:@"暂无信息"]) {
                    return @"延期单";
                }
                else {
                    int total = 0;
                    for (int i = 0;  i <  ((NSArray *)infoArray[section]).count ; i++) {
                        total += [infoArray[section][i][@"delayDays"][@"text"] intValue];
                    }
                    
                    NSString *string = [NSString stringWithFormat:@"延期单                                                                                    总天数：%d", total];
                    
                    return string;
                }
            }
            else {
                
                return @"延期单";
            }


        }
        else if (section ==1 ) {
            
            
            if ( infoArray.count != 0 ) {
                NSDictionary *d = infoArray[section][0];
                
                if ( [d[@"Reason"][@"text"] isEqualToString:@"暂无信息"]) {
                    return @"罚款单";
                }
                else {
                    int total = 0;
                    for (int i = 0;  i <  ((NSArray *)infoArray[section]).count ; i++) {
                        total += [infoArray[section][i][@"Money"][@"text"] intValue];
                    }
                    
                    NSString *string = [NSString stringWithFormat:@"罚款单                                                                                    总金额：%d", total];
                    
                    return string;
                }
            }
            else {
                
                return @"罚款单";
            }
        }
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (infotable == tableView) {
        return 30;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (infotable == tableView) {
        return 0;
    }
    if (self.dataMArray.count == section +1) {
        if (currentProcess != process) {
            
            return 0;
            
        }
        return 100;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (infotable == tableView) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] init];
    
    headerView.backgroundColor = [UIColor whiteColor];
    [[ImageView share] addToView:headerView imagePathName:@"表格-标题黄线" rect:CGRectMake(0, 44,1618/2, 1)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 1618/2, 44)];
    label.font = [UIFont boldSystemFontOfSize:25];

    [headerView addSubview:label];

    
    
    label.text = self.dataMArray[section][0][@"CheckType"][@"text"];
    return headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (infotable == tableView) {
        return nil;
    }
    
    if (self.dataMArray.count == section +1 ) {
        
        
        if (currentProcess != process) {

            return nil;
            
        }
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1618/2, 45)];
        [[Button share] addToView:footer addTarget:self rect:RectMake2x(686, 40, 246, 96) tag:1000 action:@selector(submit:) imagePath:@"按钮-提交表单"];
        

        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[Cookie getCookie:SharedAppUser.currentConstruction]];
        NSString *table = [NSString stringWithFormat:@"table%d", currentProcess];

        if ([dict[table] isEqualToString:@"1"] ) {
            return nil;
        }
        else {
            
            if ( SharedAppUser.isSignalIn == YES ) {
                return footer;
            }
        }


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
    
    [[Button share] addToView:cell.contentView addTarget:self rect:RectMake2x(1300, 3, 142, 83) tag:10909 action:@selector(selectItem:) imagePath:@"按钮-签到-00" highlightedImagePath:nil SelectedImagePath:@"按钮-签到-01"];

    [[Button share] addToView:cell.contentView addTarget:self rect:RectMake2x(1450, 3, 142, 83) tag:10908 action:@selector(selectItem:) imagePath:@"take_photo" highlightedImagePath:nil SelectedImagePath:@"take_photo"];
   
    
    
    UILabel *l = [[UILabel alloc] init];
    l.textAlignment = NSTextAlignmentCenter;
    
    l.frame = RectMake2x( 1550, 0, 20, 90);
    l.numberOfLines = 0;
    l.tag = 2014;

    [cell.contentView addSubview:l];

    
    return cell;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (infotable == tableView) {
        
        static NSString *CellIdentifier = @"Cell3h11";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if ( indexPath.section == 0 ) {
            
            NSDictionary *d =  infoArray [indexPath.section][indexPath.row];
            NSString *string = [NSString stringWithFormat:@"%@[天数：%@][%@]", d[@"reason"][@"text"],  d[@"delayDays"][@"text"],  d[@"delayDate"][@"text"]] ;

            if ( [d[@"reason"][@"text"] isEqualToString:@"暂无信息"]) {
                string = d[@"reason"][@"text"];
            }
            
            cell.textLabel.text = string;

        }
        else {
            NSString *string = [NSString stringWithFormat:@"%@",  infoArray [indexPath.section][indexPath.row][@"Reason"][@"text"]];
            cell.textLabel.text = string;
            
            
        }

        return cell;
    }
    
    
    
    
    static NSString *CellIdentifier = @"Cell3h";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [self cell3Height];
    }
    
    UIButton *button  = (UIButton *)[cell.contentView viewWithTag:10909];
    
    
//    self.dataMArray[section][0][@"Id"][@"text"],
//    NSString *str = [NSString stringWithFormat:@"%@.%@", self.dataMArray[indexPath.section][indexPath.row][@"Id"][@"text"], self.dataMArray[indexPath.section][indexPath.row][@"CheckContext"][@"text"]];

    NSMutableDictionary *currentDict =  self.dataMArray[indexPath.section][indexPath.row];
    NSMutableDictionary *dict = [Cookie getCookie:SharedAppUser.currentConstruction];
  

    UILabel *l = (UILabel *)[cell.contentView viewWithTag:2014];
    l.text = @"";
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[Cookie getCookie:SharedAppUser.currentConstruction]];
//    NSString *table = [NSString stringWithFormat:@"table%d", currentProcess];
//    
//    if ([dict[table] isEqualToString:@"1"]) {
//        return nil;
//    }
//    else {
//        return footer;
//    }

    
    
    
    
    
    if ([dict[currentDict[@"Id"][@"text"]] isEqualToString:@"1"] || currentProcess < process ) {
        button.selected = YES;
    }
    else {
        button.selected = NO;
    }

    
    cell.textLabel.text = currentDict[@"CheckContext"][@"text"];
    
    
    if ([currentDict[@"ImgCount"][@"text"] isEqualToString:@"0"]) {
        
    }
    else {
        l.text = currentDict[@"ImgCount"][@"text"];
    }

    return cell;
   
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (infotable == tableView) {
        
        
        
        if ( indexPath.section == 0 ) {
            NSDictionary *d =  infoArray [indexPath.section][indexPath.row];

            NSString *string = [NSString stringWithFormat:@"%@[天数：%@][%@]", d[@"reason"][@"text"],  d[@"delayDays"][@"text"],  d[@"delayDate"][@"text"]] ;

            [[Message share] messageAlert:string];
            
        }
        else {
            
            NSDictionary *d =  infoArray [indexPath.section][indexPath.row];

            NSString *string = [NSString stringWithFormat:@"%@[%@]",  d[@"Reason"][@"text"],  d[@"FineDate"][@"text"]];
            
            [[Message share] messageAlert:string];
        }
        
        
    }
    
}




@end
