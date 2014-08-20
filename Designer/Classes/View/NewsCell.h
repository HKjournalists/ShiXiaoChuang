//
//  NewsCell.h
//  M32
//
//  Created by i-Bejoy on 13-11-20.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//



enum {
    CellLevelOrange,
    CellLevelRed,
    CellLevelBlue,
    CellLevelGreen,
    CellLevelPurple,
};
typedef UInt32 CellLevel;


enum {

    CellTypeText,
    CellTypeImageText,
    CellTypeNew
};
typedef UInt32 CellType;



#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
{
    UIImageView *levelImageView;
    UIImageView * _dateImageView;
}


@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;


@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *likeLabel;
@property(nonatomic, assign) CellType cellType;


@property(nonatomic, strong) UIImageView *contentImageView;


- (void)levelImageView:(CellLevel)cellLevel;
- (void)setCellType:(CellType)cellType;
- (void)setReaded:(BOOL)selected;


@end
