//
//  LHRefreshTip.m
//  Lahong
//
//  Created by 宋炬峰 on 2016/10/11.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "LHRefreshTip.h"
static const CGFloat RefreshTipDuration = 2.0;
static const CGFloat RefreshTipHeight = 25.0;

@interface LHRefreshTip()
@property (nonatomic, strong) UIView* container;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, copy) dispatch_block_t nextTopAlertBlock;
@end

@implementation LHRefreshTip

+ (LHRefreshTip*)showText:(NSString*)text parentView:(UIView*)parentView{
    return [LHRefreshTip showText:text parentView:parentView withY:0];
}

+ (LHRefreshTip*)showText:(NSString*)text parentView:(UIView*)parentView withY:(CGFloat)y{
    if(text == nil || text.length == 0){
        return nil;
    }
    LHRefreshTip* tip = [[LHRefreshTip alloc] initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 25)];
    tip.titleLabel.text = text;
    [parentView addSubview:tip];
    [tip show];
    return tip;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        self.container = [[UIView alloc] initWithFrame:CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height)];
        self.container.backgroundColor = [UIColor colorWithRed:1.0 green:0x74/255.0 blue:0x74/255.0 alpha:0.7];
        [self addSubview:self.container];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.container.bounds];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.container addSubview:self.titleLabel];
    }
    return self;
}

- (void)show{
    dispatch_block_t showBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.container.layer.position = CGPointMake(self.container.layer.position.x, self.container.layer.position.y + RefreshTipHeight);
        } completion:nil];
        [self performSelector:@selector(hide) withObject:nil afterDelay:RefreshTipDuration];
    };
    
    LHRefreshTip *lastAlert = [LHRefreshTip viewWithParentView:self.superview cur:self];
    if (lastAlert) {
        lastAlert.nextTopAlertBlock = ^{
            showBlock();
        };
        [lastAlert hide];
    }else{
        showBlock();
    }
}

- (void)hide{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.container.layer.position = CGPointMake(self.container.layer.position.x, self.container.layer.position.y - RefreshTipHeight);
    } completion:^(BOOL finished) {
        if (_nextTopAlertBlock) {
            _nextTopAlertBlock();
            _nextTopAlertBlock = nil;
        }
        [self removeFromSuperview];
    }];
    /*
    if (_dismissBlock) {
        _dismissBlock();
        _dismissBlock = nil;
    }
     */
}

+ (LHRefreshTip*)viewWithParentView:(UIView*)parentView cur:(UIView*)cur{
    NSArray *array = [parentView subviews];
    for (UIView *view in array) {
        if ([view isKindOfClass:[LHRefreshTip class]] && view!=cur) {
            return (LHRefreshTip *)view;
        }
    }
    return nil;
}
@end
