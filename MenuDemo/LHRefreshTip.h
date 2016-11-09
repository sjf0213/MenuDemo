//
//  LHRefreshTip.h
//  Lahong
//
//  Created by 宋炬峰 on 2016/10/11.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHRefreshTip : UIView

+ (LHRefreshTip*)showText:(NSString*)text parentView:(UIView*)parentView;
+ (LHRefreshTip*)showText:(NSString*)text parentView:(UIView*)parentView withY:(CGFloat)y;

@end
