//
//  ShareView.m
//  M32
//
//  Created by i-Bejoy on 13-12-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ShareView.h"
#import "ZHNavigationViewController.h"
#import "WeiboSDK.h"

@implementation ShareView

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark - share



#pragma mark - email

//点击按钮后，触发这个方法
-(void)sendEMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}
//可以发送邮件的话
-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"eMail主题"];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject: @"first@example.com"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com", nil];
    [mailPicker setToRecipients: toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // 添加图片
    UIImage *addPic = [UIImage imageNamed: @"123.jpg"];
    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    // NSData *imageData = UIImageJPEGRepresentation(addPic, 1);    // jpeg
    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"123.jpg"];
    
    NSString *emailBody = @"eMail 正文";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    
    
    
    [[self viewController] presentViewController:mailPicker animated:YES completion:^{
        
    }];
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:&subject=my email!";
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [[self viewController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)shareEmailView
{
    [self sendEMail];
    NSLog(@"share email");
}




#pragma mark - message


- (void)displaySMS:(NSString *)message  {
    
    MFMessageComposeViewController*picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate= self;
    picker.navigationBar.tintColor= [UIColor blackColor];
    picker.body = message; // 默认信息内容
    // 默认收件人(可多个)
    //picker.recipients = [NSArray arrayWithObject:@"12345678901", nil];
    
    [[self viewController] presentViewController:picker animated:YES completion:^{
        
    }];
}



- (void)sendsms:(NSString *)message {
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    NSLog(@"can send SMS [%d]", [messageClass canSendText]);
    
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMS:message];
        } else {
            [self alertWithTitle:nil msg:@"设备没有短信功能"];
        }
    } else {
        [self alertWithTitle:nil msg:@"iOS版本过低，iOS4.0以上才支持程序内发送短信"];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    NSString*msg;
    
    switch (result) {
        case MessageComposeResultCancelled:
            msg = @"发送取消";
            break;
        case MessageComposeResultSent:
            msg = @"发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MessageComposeResultFailed:
            msg = @"发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    NSLog(@"发送结果：%@", msg);
    
    [[self viewController] dismissViewControllerAnimated:YES completion:^{
        
    }];}

- (void)shareMessageView
{
    NSLog(@"share message");
    
    [self sendsms:@"message"];
}


#pragma mark - wx


-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = resp.errCode ? @"Error" : @"Success";
        NSString *strError = @"There was an issue sharing your message. Please try again.";
        NSString *strSuccess = @"Your message was successfully shared!";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:resp.errCode ? strError : strSuccess
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void) sendWXTextContent :(int)scene
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"Beneath it were the words: Stay Hungry. Stay Foolish. It was their farewell message as they signed off. Stay Hungry. Stay Foolish.";
    req.bText = YES;
    
    req.scene = scene;
    
    [WXApi sendReq:req];
}


//朋友圈
- (void)shareWXTimeline
{
    NSLog(@"share wx timeline");
    
    [self sendWXTextContent:WXSceneTimeline];
}
//  好友

- (void)shareWXSession
{
    NSLog(@"share wx");
    
    
    [self sendWXTextContent:WXSceneSession];
    
}

- (void)shareWeiBoView
{
    NSLog(@"share weibo");
    
    
//    if ([SharedAppUser.accessToken isEqualToString:@""] ) {
//    
//        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//        request.redirectURI = kSinaRedirectURI;
//        request.scope = @"all";
//        request.userInfo = @{@"SSO_From": @"ShareViewController",
//                             @"Other_Info_1": [NSNumber numberWithInt:123],
//                             @"Other_Info_2": @[@"obj1", @"obj2"],
//                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//        [WeiboSDK sendRequest:request];
//    }
//    
//    else {
//        WBMessageObject *message = [WBMessageObject message];
//        
//        message.text = @"test";
//        
//        
//        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest  requestWithMessage:message];
//        request.userInfo = @{@"ShareMessageFrom":@"ShareViewController"};
//        
//        [WeiboSDK sendRequest:request];
//        
//    }
    
    
}

- (void)openShareView
{
    [UIView animateWithDuration:.3 animations:^{
        
        self.frame = RectMake2x(0, 0, 640, 497);
    }];
}

- (void)closeShareView
{
    [UIView animateWithDuration:.3 animations:^{
        
        self.frame = RectMake2x(0, screen_Height*2, 640, 497);
    }];
}


- (void)shareViewBar
{
    
    shareView = [[UIView alloc] initWithFrame:RectMake2x(0, 511, 640, 497)];
    shareView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_bg"]];
    
    
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_close"]];
    [closeButton setImage:[UIImage imageNamed:@"news_share_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = RectMake2x(268, 384, 88, 88);
    [shareView addSubview:closeButton];
    
    
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emailButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_email"]];
    [emailButton addTarget:self action:@selector(shareEmailView) forControlEvents:UIControlEventTouchUpInside];
    emailButton.frame = RectMake2x(58, 152, 91, 125);
    [shareView addSubview:emailButton];
    
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_message"]];
    [messageButton addTarget:self action:@selector(shareMessageView) forControlEvents:UIControlEventTouchUpInside];
    messageButton.frame = RectMake2x(203, 152, 91, 124);
    [shareView addSubview:messageButton];
    
    
    UIButton *wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wxButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_wx"]];
    [wxButton addTarget:self action:@selector(shareWXSession) forControlEvents:UIControlEventTouchUpInside];
    wxButton.frame = RectMake2x(347, 152, 91, 124);
    [shareView addSubview:wxButton];
    
    
    UIButton *renrenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    renrenButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"分享-朋友圈"]];
    [renrenButton addTarget:self action:@selector(shareWXTimeline) forControlEvents:UIControlEventTouchUpInside];
    renrenButton.frame = RectMake2x(492, 152, 91, 124);
    [shareView addSubview:renrenButton];
    
    
    
    
//    UIButton *weiBoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    weiBoButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_weibo"]];
//    [weiBoButton addTarget:self action:@selector(shareWeiBoView) forControlEvents:UIControlEventTouchUpInside];
//    weiBoButton.frame = RectMake2x(70, 245, 68, 96);
//    [shareView addSubview:weiBoButton];
//    
//    
//    
    [self addSubview:shareView];
//
    
    
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, screen_Height- 64)];
        b.backgroundColor = colorAlpha(0, 0, 0, .5);
        b.userInteractionEnabled = YES;

        [self addSubview:b];
        
        
        [self shareViewBar];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
