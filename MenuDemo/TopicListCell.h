//
//  TopicListCell.h
//  MenuDemo
//
//  Created by 宋炬峰 on 2016/11/9.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopicViewModel;
static CGFloat kDetaultCellH = 100;
static NSString* TopicListCellIdentifier = @"TopicListCell";

@interface TopicListCell : UITableViewCell

- (void)clearData;
- (void)loadCellData:(TopicViewModel*)topicFrame;

@end
