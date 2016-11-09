//
//  TopicViewModel.h
//  MenuDemo
//
//  Created by 宋炬峰 on 2016/11/9.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopicModel;
@interface TopicViewModel : NSObject
@property (nonatomic, strong) TopicModel *topic;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGFloat totalHeight;
@end
