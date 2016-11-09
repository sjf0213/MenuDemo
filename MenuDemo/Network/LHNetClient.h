//
//  LHNetClient.h
//  Lahong
//
//  Created by 宋炬峰 on 16/9/19.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AFNetworking;
@interface LHNetClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
+ (NSString*)mainHostURL;

// test
-(NSURLSessionDataTask* )testGetDataWithBlock:(void (^)(NSDictionary *result, NSError *error))block;
@end
