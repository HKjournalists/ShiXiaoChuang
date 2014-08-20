//
//  PdfPopoverController.m
//  Designer
//
//  Created by bejoy on 14-3-7.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "PdfPopoverController.h"

@interface PdfPopoverController ()
{

    NSArray *fileArrayM ;
    
    UITableView *tb;
    
}
@end

@implementation PdfPopoverController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadView
{
    
    [super loadView];
    

    tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 220, 470)];
    
    if ( ! iOS7) {
        tb.frame = CGRectMake(0, 0, 220, 570);
    }
    
    
    tb.dataSource = self;
    tb.delegate = self;
    
    [self.view addSubview:tb];

}

- (void)loadData
{
    
    
//    变更单在一起；、在一起；、、罚款单在一起；
    
    fileArrayM = @[ @[@"主材单", @"基材单", @"变更单"] , @[@"闭水验收", @"施工许可证"], @[@"事务处理单", @"延期单", @"罚款单"]];
    
    
    [tb reloadData];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return fileArrayM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *a = fileArrayM[section];
    return a .count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell4";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil ) {
        cell =[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
 

    NSString *string = fileArrayM[indexPath.section][indexPath.row] ;
    
    cell.textLabel.text = string;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];

    return cell;
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_popController dismissPopoverAnimated:YES];
    
    if ([_delegate respondsToSelector:@selector(selectPopover:)]) {
        [_delegate selectPopover:indexPath];
    }
}



@end
