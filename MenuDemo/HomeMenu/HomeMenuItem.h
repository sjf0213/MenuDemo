//
//  HomeMenuItem.h
//  BaGua
//
//  Created by 宋炬峰 on 16/9/18.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat HomeMenuH = 40.0f;
#define MenuTextColorNormal  NBColorFromRGB(0x787878)
#define MenuTextColorHighlight  NBColorFromRGB(0xFF0000)

@class TopicCategoryModel;

@interface HomeMenuItem : UIControl

@property(nonatomic, strong)TopicCategoryModel* model;
@property(nonatomic, assign)BOOL currSelected;
//@property(nonatomic, strong)UIColor* titleTextColor;
@property(nonatomic, readonly)UIFont* titleFont;

- (instancetype)initWithTitle:(NSString*)title;

@end
