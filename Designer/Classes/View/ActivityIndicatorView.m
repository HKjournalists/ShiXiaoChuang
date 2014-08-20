//
//  ActivityIndicatorView.m
//  Dyrs
//
//  Created by mbp  on 13-8-30.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ActivityIndicatorView.h"


static ActivityIndicatorView *aiView;

@implementation ActivityIndicatorView


+ (id)share
{
    if (aiView) {
        return aiView;
    }
    aiView = [[ActivityIndicatorView alloc] init];
    return aiView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        self.alpha = .5;
//        self.backgroundColor = [UIColor blackColor];

    }
    return self;
}


- (void)show
{
    [_aiv startAnimating];
}

- (void)hidden
{
    [_aiv stopAnimating];

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
