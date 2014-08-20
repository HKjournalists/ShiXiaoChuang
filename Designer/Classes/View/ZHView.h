//
//  ZHView.h
//  OrientParkson
//
//  Created by i-Bejoy on 13-12-21.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHView : UIView

@property(nonatomic, strong) NSMutableArray *dataMArray;
@property(nonatomic, strong) NSMutableDictionary *dataMDict;



- (void)dataReload;

@end
