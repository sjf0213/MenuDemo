//
//  MenuCategoryHelper.h
//  Lahong
//
//  Created by 宋炬峰 on 2016/9/28.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicCategoryModel : NSObject
@property(nonatomic, readonly)NSInteger index;
@property(nonatomic, readonly)NSString* categoryName;
@property(nonatomic, readonly)NSInteger categoryId;
@end

@interface TopicCategoryHelper : NSObject

+ (TopicCategoryHelper*)sharedInstance;
- (NSArray*)getTopicCategoryList;

@end
