//
//  NewsCell.m
//  M32
//
//  Created by i-Bejoy on 13-11-20.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (void)setCellType:(CellType)cellType;
{
    _cellType = cellType;
    
    
    [_titleLabel setFont:[UIFont systemFontOfSize:17]];
    _titleLabel.frame = RectMake2x(39, 19, 560, 103);

    
    
    _contentLabel.alpha = 1;
    _dateImageView.frame = RectMake2x(431, 218, 169, 30);

    
    
    
    switch (cellType) {
        case CellTypeImageText:
        {
            

            _contentImageView.alpha = 1;
            _contentImageView.frame = RectMake2x(40, 137, 140, 104);
            _contentLabel.frame = RectMake2x(209, 122, 371, 80);

            
            break;
        }
        case CellTypeText:
        {
            

            _contentLabel.frame = RectMake2x(39, 120, 548, 80);

            break;
        }
        case CellTypeNew:
        {
            
//            [_titleLabel setFont:[UIFont systemFontOfSize:17]];
            _titleLabel.frame = RectMake2x(39, 29, 540, 103);

            
            _contentLabel.alpha = 0;
            _dateImageView.frame = RectMake2x(431, 130, 169, 30);
            
            self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_cell_new_green"]];

            break;
        }
            
        default:
            break;
    }
    
    
    
}

- (void)levelImageView:(CellLevel)cellLevel
{
    
    NSString *imgNameString = nil;
    switch (cellLevel) {
        case CellLevelOrange:
        {
            imgNameString = @"newscell_level_橙色";
            break;
        }
        case CellLevelRed:
        {
            imgNameString = @"newscell_level_红色";
            break;
        }
        case CellLevelBlue:
        {
            imgNameString = @"newscell_level_蓝色";

            break;
        }
        case CellLevelGreen:
        {
            imgNameString = @"newscell_level_绿色";

            break;
        }
        case CellLevelPurple:
        {
            imgNameString = @"newscell_level_紫色";

            break;
        }
        default:
            break;
    }
    
    
    levelImageView.image = [UIImage imageNamed:imgNameString];

}




- (void)loadView
{
    
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_cell_bg_green"]];
    
    
    levelImageView = [[UIImageView alloc] init];
    levelImageView.image = [UIImage imageNamed:@"newscell_level_橙色"];
    levelImageView.frame = RectMake2x(39, 0, 61, 12);
    
    [self addSubview:levelImageView];
    
    

    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 2;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel setFont:[UIFont systemFontOfSize:18]];
    _titleLabel.frame = RectMake2x(39, 19, 560, 103);
    [_titleLabel setNumberOfLines:0];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self addSubview:_titleLabel];
    
    
    _contentImageView = [[UIImageView alloc] init];
    _contentImageView.frame = RectMake2x(40, 127, 140, 104);
    _contentImageView.alpha = 0;
    [self addSubview:_contentImageView];
    
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 3;
    [_contentLabel setFont:[UIFont systemFontOfSize:13]];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = colorAlpha(178, 178, 178, .6); //[UIColor grayColor];
    _contentLabel.frame = RectMake2x(40, 50, 560, 100);
    [_contentLabel setNumberOfLines:0];
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self addSubview:_contentLabel];
    
    
    
    
    
    _dateImageView = [[UIImageView alloc] init];
    _dateImageView.image = [UIImage imageNamed:@"newscell_date"];
    _dateImageView.frame = RectMake2x(425, 139, 169, 30);
    
    [self addSubview:_dateImageView];
    
    
    _dateLabel = [[UILabel alloc] init];
    [_dateLabel setFont:[UIFont systemFontOfSize:7]];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.frame = RectMake2x(10, 7, 175, 15);
    _dateLabel.text = @"2001-02-12";
    [_dateImageView addSubview:_dateLabel];
    
    
    _likeLabel = [[UILabel alloc] init];
    [_likeLabel setFont:[UIFont systemFontOfSize:7]];
    _likeLabel.backgroundColor = [UIColor clearColor];
    _likeLabel.frame = RectMake2x(120, 7, 142, 17);
    _likeLabel.text = @"10088";
    [_dateImageView addSubview:_likeLabel];
    

    
    
//    UIButton *newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [newsButton setBackgroundImage:[UIImage imageNamed:@"leftmenu-news-1"] forState:UIControlStateNormal];
//    [newsButton setBackgroundImage:[UIImage imageNamed:@"leftmenu-news-0"] forState:UIControlStateSelected];
//    newsButton.selected = YES;
//    newsButton.frame = RectMake(0, 77, 110, 76);
//    newsButton.tag = 100;
//    [newsButton addTarget:self action:@selector(openCenterViewController:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self addSubview:newsButton];
    
    
    

}


- (void)setReaded:(BOOL)selected
{
    if (_cellType == CellTypeNew) {
        if (!selected) {
            
            self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_cell_new_green"]];
        }
        else {
            self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_cell_new_gray"]];
        }
    }
    else {
        if (!selected) {
        
            self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_cell_bg_green"]];
        }
        else {
            self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_cell_bg_gray"]];
        }
    }

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self loadView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
