//
//  WKKViewController.h
//  CameraWithAVFoudation
//
//  Created by 可可 王 on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AFNetworking.h"

@interface WKKViewController : BaseViewController
{
    UIView *RealView;
}
@property (retain, nonatomic) UIView *RealView;
@property (retain, nonatomic) IBOutlet UIView *liveView;
@property (retain, nonatomic) IBOutlet UIImageView *Preview;


@property (weak, nonatomic) IBOutlet UIView *showView;


@property (retain, nonatomic) NSString *orderID;
@property (assign, nonatomic) NSInteger type;
@property (retain, nonatomic) NSString *itemId;
@property (retain, nonatomic) NSString *stringToConvert;





- (IBAction)back:(id)sender;
- (IBAction)redoPhoto:(id)sender;
- (IBAction)updateImage:(id)sender;

@end
