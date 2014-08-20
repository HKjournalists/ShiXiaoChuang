//
//  ZHViewController.h
//  Designer
//
//  Created by bejoy on 14-3-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKOfflineMap.h"


@interface ZHViewController : BaseViewController<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BMKOfflineMapDelegate>
{
    UIButton *currentButton;
    UIView *baseView;
    
    UICollectionView *_collectionView;
    
    BMKOfflineMap* _offlineMap;
    BMKOLSearchRecord* oneRecord;

    NSString *currentProcess;
    
    
}



@property(nonatomic, retain) NSMutableArray *viewControllers;



@end
