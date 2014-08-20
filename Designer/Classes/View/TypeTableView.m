//
//  TypeTableView.m
//  M32
//
//  Created by i-Bejoy on 13-11-21.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "TypeTableView.h"

@interface TypeTableView ()

@end

@implementation TypeTableView

- (id)init
{
    self = [super init];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91/2;
}

- (void)setSelectCell:(NSIndexPath *)index{
    
    UITableViewCell *cell = (UITableViewCell *)[self cellForRowAtIndexPath:index];
    
    cell.selected = YES;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"白色箭头"]];
 


        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_type_cell_tag"]];
        button.frame = RectMake2x(210, 20, 49, 49);
        button.tag = 10;
        button.alpha  =0;
        [button setTitle:@"0" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:button];

        
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        selectView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色横条"]];
        [cell setSelectedBackgroundView:selectView];

        cell.textLabel.textColor =[UIColor whiteColor];
    }
    
    
    NSDictionary *dict  = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"name"];
    
    

    
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:10];

    button.alpha = 0;
    
    if ( [[dict objectForKey:@"lastInfoNum"] intValue] != 0 ) {
        button.alpha = 1;
        NSString *string = [NSString stringWithFormat:@"%d", [[dict objectForKey:@"lastInfoNum"] intValue]];
        
        [button setTitle:string forState:UIControlStateNormal];
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:10];
    button.alpha = 0;
    

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:indexPath.row]];
    [dict setValue:[NSNumber numberWithInt:0] forKey:@"lastInfoNum"];
    
    
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:dict];
    
    [_typeTableViewdelegate didSelectRowAtIndexPath:indexPath ];
    
}


@end
