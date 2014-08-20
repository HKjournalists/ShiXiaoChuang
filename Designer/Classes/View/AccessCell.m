//
//  AccessCell.m
//  Dyrs
//
//  Created by zeng hui on 13-9-4.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "AccessCell.h"

@implementation AccessCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
