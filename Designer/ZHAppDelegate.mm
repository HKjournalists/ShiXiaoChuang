//
//  ZHAppDelegate.m
//  Dyrs
//
//  Created by mbp  on 13-8-12.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ZHAppDelegate.h"
#import "ZHViewController.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "XMLReader.h"

BMKMapManager *_mapManager;

@implementation ZHAppDelegate

- (void)copyData
{
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *writableDBPath = [KDocumentDirectory stringByAppendingPathComponent:@"files"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;

    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"data/files"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {

    }
    
    
    
    NSString *writableDBPath1 = [KDocumentDirectory stringByAppendingPathComponent:db_name];

    NSString *dbPath = [NSString stringWithFormat:@"data/%@", db_name];
    NSString *defaultDBPath1 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbPath];
    success = [fileManager copyItemAtPath:defaultDBPath1 toPath:writableDBPath1 error:&error];
    if (!success) {
        
    }
}



- (void)loadCurrentDate
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    //                NSDictionary *parameters = @{@"userID": @"BED3FA5F9BF747D99AC7EB9E63D75071"};
    
    NSString *urlString = [NSString stringWithFormat:@"%@Tositrust.asmx/GetServerTime", KHomeUrl];

    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *parseError = nil;
        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
        
        NSDate *date = [NSDate dateFromString:s withFormat:@"yyyy年MM月dd日HH:mm:ss"];
        
        
        [Cookie setCookie:@"datetime" value:date];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[Message share] messageAlert:KString_Server_Error];
        
        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //    [MTA startWithAppkey:@"IWQVM4V749EQ"];
    //    [[MTAConfig getInstance] setSessionTimeoutSecs:60];
    
    // 要使用百度地图，请先启动BaiduMapManager
	_mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:KBMapAppKey generalDelegate:self];
	if (!ret) {
		NSLog(@"manager start failed!");
	}

    
    
    

    
    NSString *currentUser = [Cookie getCookie:KCurrentUser];

    //   清除 数据
    if (currentUser != nil) {
//            [Cookie setCookie:KCurrentUser value:nil];
//            [Cookie setCookie:currentUser value:nil];
    }
    
    self.user = [[User alloc] init];



    
    

    if (currentUser != nil) {
        
        
        NSDictionary *dict = [Cookie getCookie:currentUser];

        SharedAppUser.ID  =     [dict objectForKey:@"id"];
        SharedAppUser.account = [dict objectForKey:@"account"];
        SharedAppUser.name =    [dict objectForKey:@"nickName"];

    }
    
    //    当前登录用户
    DLog(@"%@", SharedAppUser);
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self copyData];

    ZHViewController *masterViewController = [[ZHViewController alloc] init];

    _masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    _masterNavigationController.navigationBarHidden =YES;
//    _masterNavigationController.view.backgroundColor = [UIColor clearColor];

//    [masterNavigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    self.window.rootViewController = _masterNavigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetHomeAnimationViewFrame" object:nil userInfo:nil];

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    
    [self loadCurrentDate];
    
    int endDays =  7;
    
    NSString *name = [KNSUserDefaults objectForKey:KCurrentUser];
    
    
    
    if  (  name != nil ) {
        
        
        
        NSString *currentUser = [Cookie getCookie:KCurrentUser];
        
        NSDictionary *dict = [Cookie getCookie:currentUser];
        NSDate *date = [dict objectForKey:@"date"];
        NSDate *now = [NSDate date]; //[NSDate dateFromString:@"28-1-2014"];
        int days = [NSDate dateCommpe:date now:now];
        
        if (days <= endDays) {
            
            
            NSString *loginOut = [KNSUserDefaults objectForKey:@"out"];
            
            
            if ( loginOut != nil) {
                
                [KNSUserDefaults setObject:nil forKey:@"out"];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_GetUserProfileSuccess" object:nil userInfo:nil];
                return;
            }
            
            
            
        }
        else {
            
            [Cookie setCookie:KCurrentUser value:nil];
            [Cookie setCookie:currentUser value:nil];
        }
    }
    
    
    
    
    
    if ([_masterNavigationController.topViewController class] == [LoginViewController class]) {
        return;
    }
    
    LoginViewController *lvc = [[LoginViewController alloc] init];
    lvc.view.alpha = 0;
    
    [UIView animateWithDuration:KMiddleDuration animations:^{
        lvc.view.alpha = 1;
    }];
    
    [_masterNavigationController.view addSubview:lvc.view];
    [_masterNavigationController addChildViewController:lvc];
    
    
//    [_masterNavigationController pushViewController:lvc animated:NO];
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
