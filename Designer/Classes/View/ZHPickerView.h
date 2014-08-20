//
//  ZHPickerView.h
//  ShiXiaoChuang
//
//  Created by bejoy on 14-5-23.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHPickerViewDelegate <NSObject>

- (void)selectResult:(NSString *)string  currentString:(NSString *)currentString;;

@end

@interface ZHPickerView : UIView
{
    UIScrollView *currentScrollView;
    NSMutableDictionary *resultDict;
}



@property(nonatomic, strong) NSArray *currentDataArray;
@property(nonatomic, strong) NSArray *dataArray;

@property(nonatomic, strong) id<ZHPickerViewDelegate> delegate;

@property(nonatomic, assign) int cloumnCount;
@property(nonatomic, assign) int cloumnWidth;

@end
