//
//  WKKViewController.m
//  CameraWithAVFoudation
//
//  Created by 可可 王 on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WKKViewController.h"
#import "CameraImageHelper.h"
#import "XMLReader.h"
#import "SVProgressHUD.h"
#import "UIButton+WebCache.h"

@interface WKKViewController ()
@property(retain,nonatomic) CameraImageHelper *CameraHelper;
@end

@implementation WKKViewController
@synthesize RealView;
@synthesize liveView;
@synthesize Preview;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
    self.baseView.alpha  = 0;
    
    _CameraHelper = [[CameraImageHelper alloc]init];
    
    // 开始实时取景
    [_CameraHelper startRunning];
    [_CameraHelper embedPreviewInView:self.liveView];

    [_CameraHelper changePreviewOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    
    _showView.alpha = 0;
    
    [self getNetImages];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:YES];
    
    [self setPreview:nil];
    
    [_CameraHelper stopRunning];
    [_CameraHelper removeAVObserver];
    
    
    
    [self setRealView:nil];
    [self setLiveView:nil];
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_CameraHelper changePreviewOrientation:(UIInterfaceOrientation)toInterfaceOrientation];
}


- (void)putImage
{
    
    
    [SVProgressHUD showWithStatus:@"正在上传图片..." maskType:SVProgressHUDMaskTypeGradient];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
//    UIImage *i = [UIImage imageNamed:@"按钮-材料变更单-1"];
//    NSData *d = [NSData dataWithData: UIImagePNGRepresentation(i)];
//
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    
//    NSData *dataImage = [[NSData alloc] init];
//    dataImage = UIImagePNGRepresentation(i);
    NSData *data =  UIImageJPEGRepresentation(self.Preview.image, .8);

    NSString * str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    
    
    NSDictionary *parameters = @{ @"stringToConvert":  str,
                                  @"orderId":_orderID,
                                  @"itemId": _itemId,
                                  @"type": [NSNumber numberWithInt:_type]};
 
    NSString *urlString = [NSString stringWithFormat:@"%@Tositrust.asmx/UploadImage", KHomeUrl];

    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];

        
        [self redoPhoto:nil];
        
        NSError *parseError = nil;
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        
        if ( [s isEqualToString:@"成功"]) {
            [[Message share] messageAlert:@"上传成功，您可以继续拍照上传!"];
            
            [self getNetImages];
        }
        else {
            [[Message share] messageAlert:@"上传失败，请稍后尝试。"];

        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self redoPhoto:nil];
        [[Message share] messageAlert:KString_Server_Error];
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    
}

- (void)clipImage
{
    
//    CGSize size = CGSizeMake( 768/2, 768/2) ;
//    UIImage *image = [Image squareImageWithImage:[_CameraHelper image] scaledToSize:size];

    CGSize size = CGSizeMake( [_CameraHelper image].size.width* 1/5, [_CameraHelper image].size.height* 1/5) ;
    UIImage *image = [Image imageWithImage:[_CameraHelper image] scaledToSize:size];
    
    
//    NSString *string = [NSString stringWithFormat:@"str%d.jpeg", arc4random()%5];
//    NSString *sPath = KDocumentName(string);
    
    
//    NSData *data =  UIImageJPEGRepresentation(image, .8);
//    [data writeToFile:sPath atomically:YES];
//    NSLog(@"%f,%f",image.size.height,image.size.width);
    if (image) {
        self.Preview.image = image;
        
        
        _showView.alpha = 1;
    }
    
    

}

-(void)getImage
{
    [self clipImage];
  
}

- (IBAction)snapPressed:(id)sender {


    if (self.dataMArray.count == 5) {
        
        [[Message share] messageAlert:@"已经到达了可拍摄照片的最大数量，  请点击左下角的返回！"];
        return;
    }
    
    [_CameraHelper CaptureStillImage];
    [self performSelector:@selector(getImage) withObject:nil afterDelay:0.5];
}

- (IBAction)back:(id)sender {
  
//    if (self.dataMArray.count == 0) {
//        
//        [[Message share] messageAlert:@"至少要拍摄一张照片 ！"];
//
//        return;
//    }
    
    [super back:nil];
//    [self.view addSubview:kVC.view];
//    [self addChildViewController:kVC];
    
}

- (IBAction)redoPhoto:(id)sender {
    
    _showView.alpha = 0;
    Preview.image = nil;

}

- (IBAction)updateImage:(id)sender {
    

    [self putImage];

}


- (void)closeMe:(UIButton *)button
{
    [button removeFromSuperview];
}

- (void)openView:(UIButton *)button
{
  
    
    UIButton *b =  [[Button share] addToView:self.view addTarget:self rect:  self.view.frame  tag:2100 action:@selector(closeMe:)];
    b.frame = self.view.frame;
    
    
    [b setImage:button.imageView.image forState:UIControlStateNormal];

}

- (void)scrollV
{
    
    for (int  i = 1000; i < 1006; i ++) {
        
        UIButton *b = (UIButton *)[self.view viewWithTag:i];
        
        if (b) {
            [b removeFromSuperview];
        }
    }
    
    int x = 390;
    int y =  1260;

    for (int i = 0;  i< self.dataMArray.count; i++) {
        
        UIButton *b =  [[Button share] addToView:self.view addTarget:self rect:RectMake2x(x + i*323 , y, 317, 236) tag:i +1000 action:@selector(openView:)];
        NSString *string = self.dataMArray[i][@"text"];
        NSURL *url = [[NSURL alloc] initWithString:string];

        [b setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"照相页面-小图-底图"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {

        }];
    }
}

- (void)getNetImages
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    NSDictionary *parameters = @{
                                  @"orderId":_orderID,
                                  @"itemId": _itemId,
                                  @"type": [NSNumber numberWithInt:_type]};
    
    NSString *urlString = [NSString stringWithFormat:@"%@Tositrust.asmx/GetImageInfo", KHomeUrl];

    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSError *parseError = nil;
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSDictionary *dictionary= [XMLReader dictionaryForXMLString:s error:&parseError];

        
        if ( [dictionary[@"ArrayOfString"][@"string"] isKindOfClass:[NSMutableDictionary class]] ) {
            
            self.dataMArray = [[NSMutableArray alloc]     initWithObjects: dictionary[@"ArrayOfString"][@"string"], nil];
        }
        else {
            
            self.dataMArray = dictionary[@"ArrayOfString"][@"string"];
        }
        [self scrollV];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[Message share] messageAlert:KString_Server_Error];
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
}
@end
