//
//  Unit.h
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//


typedef enum {
    AccessoriesTable = -1,
    
} Tables_name;

typedef enum {
    Action_AD = 1,
    Action_Series = 2,
    Action_Category,
    Action_Update,
    Action_Seach,
    Action_Back,
    Action_ProductionList,
    Action_ProductionDetail,

} Action;



#define AppName @"OrientParkson"
#define AppVersion @"1.0"
#define App_Auther @"zenghui"



#define KProjectNameHaro @"haro"
#define KCurrentProjectName @"OrientParkson"
#define KCurrentUser @"currentUser"
#define KCurrentUser_version @"version"






#define db_name @"data.sqlite"

#define isLandscape 1
#define isShowStatue 1




#define iOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)?YES:NO


#define Statue_success @"100"
#define Statue_failure @"101"



#define color(r, g, b) [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1]
#define colorAlpha(r, g, b, a) [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:a]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define backgroundSize CGRectMake(0, 0, 1024, 768)

#define screen_Width [[UIScreen mainScreen] bounds].size.width
#define screen_Height [[UIScreen mainScreen] bounds].size.height


#define screen_BOUNDS_SIZE CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)
#define screen_BOUNDS(NUM) CGRectMake(0, NUM*768, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)

#define screen_SIZE(NUM) CGSizeMake(NUM*1024, 768)
#define screen_SIZEHeight(NUM) CGSizeMake(1024, NUM*768)



#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define FILEPATH [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self dateString]]

#define MAINBUNDLE [NSBundle mainBundle]


#define IMAGESIZEWIDTH(img) img.size.width/2
#define IMAGESIZEHEIGHT(img) img.size.height/2

#define IMAGEVIEWSIZEWIDTH(imgView) imgView.image.size.width/2
#define IMAGEVIEWSIZEHEIGHT(imgView) imgView.image.size.height/2

#define BUTTONSIZEWIDTH(BTN) BTN.frame.size.width
#define BUTTONSIZEHEIGHT(BTN) BTN.frame.size.height


#define KNSUserDefaults [NSUserDefaults standardUserDefaults] 



#define KDocumentDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define KDocumentDirectoryFiles [KDocumentDirectory stringByAppendingPathComponent:@"/files"]
#define KDocumentName(fileName) [NSString stringWithFormat:@"%@/%@",  KDocumentDirectoryFiles ,fileName]





#define KisHaro [KCurrentProjectName isEqualToString:KProjectNameHaro]
#define KisDyrs [KCurrentProjectName isEqualToString:KProjectNameDyrs]

//#define SharedAppDelegate ((ZHAppDelegate *)[[UIApplication sharedApplication] delegate])
//#define SharedApplication [UIApplication sharedApplication]

#define SharedAppUser ((ZHAppDelegate *)[[UIApplication sharedApplication] delegate]).user

#define M_PI 3.14159265358979323846264338327950288
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)




#define Kinsert @"1"
#define Kdelete @"2"
#define Kupdate @"3"



#define KPageSize 10
#define KDuration .3
#define KMiddleDuration .5
#define Kdamping .3
#define KLongDuration 1


//#ifdef DEBUG
//#define KHomeUrl @"http://124.202.145.74:8815/"
//#else
#define KHomeUrl @"http://oa.sitrust.cn:8001/"
//#endif




#pragma mark -  SD 自动arc 适应

#define SDWIRetain(__v) ([__v retain]);
#define SDWIReturnRetained SDWIRetain

#define SDWIRelease(__v) ([__v release]);
#define SDWISafeRelease(__v) ([__v release], __v = nil);
#define SDWISuperDealoc [super dealloc];


#pragma mark -  账号

//  淘宝

#define KTaoBaoAppKey @""
#define KTaoBaoSecert @""

#define KAppredirect_uri @"http://gediaoer.com"
#define KTaoBaoCallbackUrl @"gediaoercallback://"



#define KwxAppID @""
#define KwxAppKey @"2338c93f0688b3085753d1179ccdba5d"




#define kSinaAppKey         @""
#define kSinaRedirectURI    @"https://api.weibo.com/oauth2/default.html"

#define kD_Id @"1"

#define KBMapAppKey @"36q4YEvrqPImRbqzParsh5cd"




#pragma mark -  扩展


CG_INLINE CGRect
RectMake2x(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
//    if (iOS7) {
//        rect.origin.x = x/2; rect.origin.y = y/2;
//    }
//    else {
        rect.origin.x = x/2; rect.origin.y = y/2;
        
//    }
    rect.size.width = width/2; rect.size.height = height/2;
    return rect;
}

CG_INLINE CGRect
RectMakeC2x(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;

    rect.origin.x = x/2; rect.origin.y = (y)/2;
    
    rect.size.width = width/2; rect.size.height = height/2;
    return rect;
}



