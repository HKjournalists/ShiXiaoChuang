//
//  ShareView.h
//  M32
//
//  Created by i-Bejoy on 13-12-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WXApi.h"
#import "WeiboSDK.h"


@interface ShareView : UIView<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, WBHttpRequestDelegate>
{
    UIView *shareView;
}

@property(nonatomic, strong) NSDictionary *shareDict;
@property(nonatomic, assign) id delegate;


@end
