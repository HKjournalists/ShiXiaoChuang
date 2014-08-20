//
//  productCCell.h
//  OrientParkson
//
//  Created by i-Bejoy on 14-1-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuiKuanCell : UICollectionViewCell
{
 
    UILabel *ctnameLabel;
    UILabel *pbNameLabel;
    
}


@property (weak, nonatomic) IBOutlet UIImageView *endImageView;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;

@property(nonatomic, assign) NSInteger type;

@property(nonatomic, strong) NSDictionary *dict;
@property(nonatomic, strong) IBOutlet UIImageView *imgView1;
@property(nonatomic, strong) UILabel *ctnameLabel;
@property(nonatomic, strong) UILabel *pbNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *construc_TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coustomer_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coustomer_phone;
@property (weak, nonatomic) IBOutlet UILabel *adreeLable;
@property (weak, nonatomic) IBOutlet UILabel *foremanNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *foreman_phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *designer_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designer_phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *pactNumLabel;

@end
