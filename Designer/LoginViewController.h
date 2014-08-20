//
//  LoginViewController.h
//  OrientParkson
//
//  Created by i-Bejoy on 13-12-23.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"
#import "ZHPassDataJSON.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"



@interface LoginViewController : UIViewController<UITextFieldDelegate, DownloaderDelegate, ZHPassDataJSONDelegate>
{
    UITextField *nameTextField;
    UITextField *passwordTextField;
    
    UIView *loginBackGroundView;
    NSMutableArray *picArray;

}

@property(nonatomic, assign) id delegate;

@property (nonatomic, strong) PendingOperations *pendingOperations;



@end
