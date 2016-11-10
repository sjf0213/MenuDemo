//
//  TopicListView.m
//  MenuDemo
//
//  Created by 宋炬峰 on 2016/11/9.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "TopicListView.h"
#import "TopicListCell.h"
@interface TopicListView()
@property(nonatomic, strong)UIImageView* bgImgView;
@end
@implementation TopicListView

-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.rowHeight = kDetaultCellH;
        
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height * 1.5)];
        [self addSubview:self.bgImgView];
        
        UIImage* bgImg = [UIImage imageNamed:@"blanklist375"];
        NSInteger w = [UIScreen mainScreen].bounds.size.width;
        switch (w) {
            case 320:
                bgImg = [UIImage imageNamed:@"blanklist320"];
                break;
            case 375:
                bgImg = [UIImage imageNamed:@"blanklist375"];
                break;
            case 414:
                bgImg = [UIImage imageNamed:@"blanklist414"];
                break;
            default:
                break;
        }
        self.bgImgView.backgroundColor = [[UIColor alloc] initWithPatternImage:bgImg];
        
    }
    return self;
}

-(void)setShowBg:(BOOL)showBg{
    _showBg = showBg;
    if (showBg) {
        self.bgImgView.hidden = NO;
    }else{
        self.bgImgView.hidden = YES;
    }
}

@end
