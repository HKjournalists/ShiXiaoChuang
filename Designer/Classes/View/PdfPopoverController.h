//
//  PdfPopoverController.h
//  Designer
//
//  Created by bejoy on 14-3-7.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//


@protocol PdfPopoverDelegate <NSObject>

- (void)selectPopover:(NSIndexPath *)index;

@end

@interface PdfPopoverController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain)    id<PdfPopoverDelegate> delegate;



@property(nonatomic, strong) UIViewController *viewController;
@property(nonatomic, strong) UIPopoverController *popController;

@end
