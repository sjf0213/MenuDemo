//
//  HomeScrollMenu.h
//  BaGua
//
//  Created by 宋炬峰 on 16/9/18.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopicCategoryModel;

@interface HomeScrollMenu : UIView
@property(readonly, nonatomic)NSInteger itemCount;
@property(readonly, nonatomic)NSInteger currIndex;
@property(copy, nonatomic)void(^tapItemHandler)(TopicCategoryModel* model);
-(void)setCurrSelected:(NSInteger)index;// 由滑动引起
-(void)setCurrFloatPos:(CGFloat)pos;// 由滑动引起de浮点动态位置
-(TopicCategoryModel*)categoryModelInPosition:(NSInteger)index;
@end
