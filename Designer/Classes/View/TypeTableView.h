//
//  TypeTableView.h
//  M32
//
//  Created by i-Bejoy on 13-11-21.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "TableView.h"

@protocol TypeTableViewDelegate <NSObject>

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface TypeTableView : TableView<UITableViewDataSource, UITableViewDelegate>

//@property(nonatomic, assign) int selectCell;

@property(nonatomic, assign) id<TypeTableViewDelegate> typeTableViewdelegate;
@property(nonatomic,retain) NSMutableArray *dataArray;


- (void)setSelectCell:(NSIndexPath *)index;


@end


