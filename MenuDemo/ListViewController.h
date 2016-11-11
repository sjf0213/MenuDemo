//
//  ListViewController.h
//  MenuDemo
//
//  Created by 宋炬峰 on 2016/11/9.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopicListView;

@interface ListViewController : UIViewController

@property(nonatomic, assign)NSInteger categoryId;
@property(nonatomic, assign)BOOL notVisible;

-(instancetype)initWithFrame:(CGRect)frame;
@end
