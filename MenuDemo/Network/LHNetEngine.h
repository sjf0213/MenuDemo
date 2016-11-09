//
//  LHNetEngine.h
//  Lahong
//
//  Created by 宋炬峰 on 16/9/19.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHNetEngine : NSObject

+(LHNetEngine*)sharedInstance;
//分类文章列表
+(NSURLSessionDataTask *)getTopicListDataByCategory:(NSInteger)cate pageIndex:(NSInteger)p completion:(void (^)(NSDictionary *result, NSError *error))block;

@end
