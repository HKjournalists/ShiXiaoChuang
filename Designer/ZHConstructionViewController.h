//
//  ZHConstructionViewController.h
//  ShiXiaoChuang
//
//  Created by bejoy on 14-4-17.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"
#import "PdfPopoverController.h"
#import "BMapKit.h"


@interface ZHConstructionViewController : BaseViewController<PdfPopoverDelegate, UIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate, BMKMapViewDelegate>
{
    UITableView *tb;
    UIView *tbBaseView;
    
    UIButton *currentButton;
    bool isSingnal;
    
    int currentProcess;
    int process;

    __weak IBOutlet UITableView *infotable;
    NSMutableArray *infoArray;
    
    
}
@property (nonatomic, strong) UIPopoverController *popover;

@property (strong, nonatomic) IBOutlet UIView *constructinoView;


@property (weak, nonatomic) IBOutlet UILabel *construc_TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coustomer_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coustomer_phone;
@property (weak, nonatomic) IBOutlet UILabel *adreeLable;
@property (weak, nonatomic) IBOutlet UILabel *foremanNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *foreman_phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *designer_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designer_phoneLabel;
@property (weak, nonatomic) IBOutlet BMKMapView *baidu_MapView;
@property (weak, nonatomic) IBOutlet UILabel *jingliangStataLabel;

@property (weak, nonatomic) IBOutlet UIButton *outButton;
@property (weak, nonatomic) IBOutlet UIButton *sinButton;
@property (weak, nonatomic) IBOutlet UILabel *packNumLabel;

- (IBAction)addSignalIN:(id)sender;
- (IBAction)addSignalOut:(id)sender;


@end
