//
//  ApiBuilder.h
//  Lahong
//
//  Created by 宋炬峰 on 16/9/21.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiBuilder : NSObject

+(ApiBuilder*)shareInstance;

#pragma mark - 接口列表
// App配置
+(NSString *)appConfig:(NSDictionary*)dic;
//分类文章列表
+(NSString *)topicListData:(NSDictionary*)dic;
@end
