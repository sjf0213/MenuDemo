//
//  HomeMenuItem.m
//  BaGua
//
//  Created by 宋炬峰 on 16/9/18.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "HomeMenuItem.h"
#import "TopicCategoryHelper.h"

const CGFloat defualtW = 50;

@interface HomeMenuItem()
@property(nonatomic, strong)UILabel* titleLabel;
@end
@implementation HomeMenuItem

- (instancetype)initWithTitle:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, 0, defualtW, HomeMenuH-0.5)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = MenuTextColorNormal;
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(UIFont*)titleFont{
    return self.titleLabel.font;
}

-(void)setModel:(TopicCategoryModel *)model{
    _model = [model copy];
    self.titleLabel.text = model.categoryName;
}

-(void)setCurrSelected:(BOOL)currSelected{
    _currSelected = currSelected;
    
    if (currSelected) {
        self.titleLabel.textColor = MenuTextColorHighlight;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }else{
        self.titleLabel.textColor = MenuTextColorNormal;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
    }
}

-(void)layoutSubviews{
    self.titleLabel.frame = self.bounds;
}
@end
