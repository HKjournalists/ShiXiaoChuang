//
//  productCCell.m
//  OrientParkson
//
//  Created by i-Bejoy on 14-1-3.
//  Copyright (c) 2014年 zeng hui. All rights reserved.
//

#import "ProductCCell.h"

@implementation ProductCCell

//-(void)awakeFromNib
//{
//    UIImageView *img1 = [[ImageView share] addToView:self imagePathName:@"提示符号-没完成" rect:RectMake2x(139, 356, 70, 70)];
//    img1.tag  = 20001;
//    UIImageView *img2 =[[ImageView share] addToView:self imagePathName:@"提示符号-完成" rect:RectMake2x(353, 356, 70, 70)];
//    img2.tag  = 20002;
//
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        
        // Initialization code
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"productlist_cell"]];
//        _imgView1 = [[ImageView share] addToView:self
//                                               imagePathName:nil rect:RectMake2x(2, 2, 462, 384)];
//        
//        
//        
//        [[Button share] addToView:self addTarget:self rect:RectMake2x(0, 0, 466, 388) tag:301 action:@selector(openProductDetail:)];
        
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
    _imgView1.image  = [UIImage imageNamed:@"construction_cell_bg"];
    
    _imgView1.contentMode =  UIViewContentModeScaleAspectFit;



    
    NSMutableDictionary *currentConstructiondict = [NSMutableDictionary dictionaryWithDictionary:[Cookie getCookie:dict[@"Id"][@"text"]]];
    NSString *sinString =[NSString stringWithFormat:@"sin%@", [NSDate stringFromDate:[Cookie getCookie:@"datetime"] withFormat:@"yyyy-MM-dd"]];

    if ([currentConstructiondict[sinString] isEqualToString:@"1"]) {
        _imgView1.image  = [UIImage imageNamed:@"construction_cell_bg_1"];
    }

    
    
    ctnameLabel.text = [dict objectForKey:@"Description"];
    pbNameLabel.text = [dict objectForKey:@"CustomerName"];

    _construc_TypeLabel.text = dict[@"Description"][@"text"];
    _coustomer_nameLabel.text = dict[@"CustomerName"][@"text"];
    _coustomer_phone.text = dict[@"CustomerPhone"][@"text"];
    _adreeLable.text = dict[@"Address"][@"text"];
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
