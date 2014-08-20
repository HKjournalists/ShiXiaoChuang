//
//  productCCell.m
//  OrientParkson
//
//  Created by i-Bejoy on 14-1-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "CuiKuanCell.h"

@implementation CuiKuanCell

//-(void)awakeFromNib
//{
//    UIImageView *img1 = [[ImageView share] addToView:self imagePathName:@"提示符号-没完成" rect:RectMake2x(139, 356, 70, 70)];
//    img1.tag  = 20001;
//    UIImageView *img2 =[[ImageView share] addToView:self imagePathName:@"提示符号-完成" rect:RectMake2x(353, 356, 70, 70)];
//    img2.tag  = 20002;
//    
//    
//    _construc_TypeLabel.frame = RectMake2x(23, 15, 190, 38);
//    _coustomer_nameLabel.frame = RectMake2x(82, 90, 95, 33);
//    _coustomer_phone.frame = RectMake2x(286, 92, 208, 33);
//    _foremanNameLabel.frame = RectMake2x(82, 186, 95, 33);
//    _foreman_phoneLabel.frame = RectMake2x(82, 186, 95, 33);
//    _designer_nameLabel.frame = RectMake2x(82, 278, 63, 33);
//    _designer_phoneLabel.frame = RectMake2x(286, 278, 208, 33);
//    
//
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [[ImageView share] addToView:_imgView1 imagePathName:@"productlist_cell_blackbox" rect:RectMake2x(10, 285, 446, 93)];
        
        
        ctnameLabel = [[UILabel alloc] initWithFrame:RectMake2x(25, 285, 446, 43)];
        ctnameLabel.font = [UIFont systemFontOfSize:13];
        ctnameLabel.textColor = [UIColor whiteColor];
        ctnameLabel.tag = 201;
        
        pbNameLabel = [[UILabel alloc] initWithFrame:RectMake2x(25, 325, 446, 43)];
        pbNameLabel.font = [UIFont systemFontOfSize:16];
        pbNameLabel.textColor = [UIColor whiteColor];
        pbNameLabel.tag = 2001;
        
        [_imgView1 addSubview:ctnameLabel];
        [_imgView1 addSubview:pbNameLabel];

    }
    return self;
}

- (void)setDict:(NSDictionary *)dict
{
    if (_dict != dict) {
        _dict = dict;
    }

    
    
//    _imgView1.image  = [UIImage imageNamed:@"construction_cell_bg"];
    _imgView1.contentMode =  UIViewContentModeScaleAspectFit;

    
//    NSMutableDictionary *currentConstructiondict = [NSMutableDictionary dictionaryWithDictionary:[Cookie getCookie:dict[@"Id"][@"text"]]];
//    NSString *sinString =[NSString stringWithFormat:@"sin%@", [NSDate stringFromDate:[Cookie getCookie:@"datetime"] withFormat:@"yyyy-MM-dd"]];
//
//    if ([currentConstructiondict[sinString] isEqualToString:@"1"]) {
////        _imgView1.image  = [UIImage imageNamed:@"construction_cell_bg_1"];
//    }

    
    if ( [dict[@"EndState"][@"text"] isEqualToString:@"0"]) {
        _endImageView.image = [UIImage imageNamed:@"提示符号-没完成.png"];
    }
    else {
        _endImageView.image = [UIImage imageNamed:@"提示符号-完成.png"];
    }
    
    
    if ( [dict[@"MidState"][@"text"] isEqualToString:@"0"]) {
        _midImageView.image = [UIImage imageNamed:@"提示符号-没完成.png"];
    }
    else {
        _midImageView.image = [UIImage imageNamed:@"提示符号-完成.png"];
    }
    
    ctnameLabel.text = [dict objectForKey:@"Description"];
    pbNameLabel.text = [dict objectForKey:@"CustomerName"];

    _construc_TypeLabel.text = dict[@"Description"][@"text"];
    _coustomer_nameLabel.text = dict[@"CustomerName"][@"text"];
    _coustomer_phone.text = dict[@"CustomerPhone"][@"text"];
//    _adreeLable.text = dict[@"Address"][@"text"];
    _foremanNameLabel.text = dict[@"ForemanName"][@"text"];
    _foreman_phoneLabel.text = dict[@"ForemanPhone"][@"text"];
    _designer_nameLabel.text = dict[@"DesignerName"][@"text"];
    _designer_phoneLabel.text = dict[@"DesignerPhone"][@"text"];
    _pactNumLabel.text = dict[@"PactNumer"][@"text"];

   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
