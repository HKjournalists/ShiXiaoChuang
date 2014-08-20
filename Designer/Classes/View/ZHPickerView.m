//
//  ZHPickerView.m
//  ShiXiaoChuang
//
//  Created by bejoy on 14-5-23.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ZHPickerView.h"

@implementation ZHPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        resultDict = [[NSMutableDictionary alloc] init];
        
        _cloumnCount = 0;
        _cloumnWidth = 0;
    }
    return self;
}

-(void)top:(UIButton *)button
{
    int currentIndex = button.superview .tag;
    
    if ( currentIndex == 1) {
        [resultDict setObject:button.titleLabel.text forKey:@"1"];
        [resultDict setObject:@"" forKey:@"2"];
        [resultDict setObject:@"" forKey:@"3"];

    }
    if ( currentIndex == 2) {
        [resultDict setObject:button.titleLabel.text forKey:@"2"];
        [resultDict setObject:@"" forKey:@"3"];

    }
    if ( currentIndex == 3) {
        [resultDict setObject:button.titleLabel.text forKey:@"3"];
    }
    
    
    UIScrollView *v = (UIScrollView *)[self viewWithTag:currentIndex];

    for (UIButton *b in v.subviews) {
        b.backgroundColor = [UIColor clearColor];
        
        if ([b.class isSubclassOfClass:[UIButton class]]) {
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal] ;

        }

    }
    
    
    button.backgroundColor = [UIColor orangeColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;


    if (currentIndex == _cloumnCount) {
        
        NSMutableString *ms = [[NSMutableString alloc] init];
       
        for (NSString *s in resultDict.allValues ) {
            
            [ms appendFormat:@"%@ ", s ];
        }

        [ms substringWithRange:NSMakeRange(0, ms.length-5)];
        [self.delegate selectResult:ms currentString:resultDict.allValues.lastObject];
        
        return;
    }
    [self reloadDataForIndex:currentIndex string:button.titleLabel.text];
    
    
}

-(void)reloadDataForIndex:(int)index string:(NSString *)string
{
    _currentDataArray = _dataArray[index];
    
    
    UIScrollView *v1 = (UIScrollView *)[self viewWithTag:1];
    UIScrollView *v2 = (UIScrollView *)[self viewWithTag:2];
    UIScrollView *v3 = (UIScrollView *)[self viewWithTag:3];
    



    if (_currentDataArray.count == 0    ) {

        return;
    }
    
    
    int i = 0;
    int hight = 44;
    

    
    if (index == 0) {
        currentScrollView = v1;
        
        for (UIView *v in v2.subviews) {
            [v removeFromSuperview];
        }
        for (UIView *v in v3.subviews) {
            [v removeFromSuperview];
        }
        
    } else if (index == 1) {
        currentScrollView = v2;
        
        for (UIView *v in v2.subviews) {
            [v removeFromSuperview];
        }
        for (UIView *v in v3.subviews) {
            [v removeFromSuperview];
        }
        
    } else if (index == 2) {
        currentScrollView = v3;

        for (UIView *v in v3.subviews) {
            [v removeFromSuperview];
        }
    }
    
    
    
    if ([string isEqualToString:@""]) {
        
        
        
        
        for (NSString *s in  _currentDataArray) {
            
            UIButton *b =  [[Button share] addToView:currentScrollView addTarget:self rect:CGRectMake(0, i * hight, _cloumnWidth, hight) tag:i+100 action:@selector(top:)];
            [b setTitle:s forState:UIControlStateNormal];
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            i ++;
        }
        
        
        [currentScrollView setContentSize:CGSizeMake(_cloumnWidth, hight *_currentDataArray.count)];
    }
    else {
        
        
        
        NSMutableArray *a = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in _currentDataArray) {
            
            
            
            if (dict[string]) {
                [a addObject:dict[string]];
            }

            
        }
        
        
        if (a.count == 0) {
            
            
            NSMutableString *ms = [[NSMutableString alloc] init];
            
            for (NSString *s in resultDict.allValues ) {
                
                [ms appendFormat:@"%@ ", s ];
            }
            
            [ms substringWithRange:NSMakeRange(0, ms.length-5)];
            [self.delegate selectResult:ms currentString:resultDict.allValues.lastObject];
            
            return;
        }
        
        for (NSString *s in  a) {
            
            UIButton *b =  [[Button share] addToView:currentScrollView addTarget:self rect:CGRectMake(0, i * hight, _cloumnWidth, hight) tag:i+100 action:@selector(top:)];
            [b setTitle:s forState:UIControlStateNormal];
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            i ++;
        }
        
        
        [currentScrollView setContentSize:CGSizeMake(_cloumnWidth, hight *a.count)];
    }
    
    
    
    
    
    
    
}

-(void)setDataArray:(NSArray *)dataArray
{
    
    if (dataArray == _dataArray) {
        return;
    }

    _dataArray = dataArray;
    
    [self reloadDataForIndex:0 string:@""];
    
}


- (void)setCloumnCount:(int)cloumnCount
{
    if (cloumnCount == _cloumnCount) {
        return;
    }
    _cloumnWidth = self.frame.size.width / cloumnCount;
    _cloumnCount = cloumnCount;
    
    for (int i = 0; i < cloumnCount; i ++) {
        
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv .tag = i +1;
        sv.frame = CGRectMake(_cloumnWidth * i, 0, _cloumnWidth, self.frame.size.height);
        
        [self addSubview:sv];
    }
}



@end
