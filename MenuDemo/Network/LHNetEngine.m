//
//  LHNetEngine.m
//  Lahong
//
//  Created by 宋炬峰 on 16/9/19.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "LHNetEngine.h"
#import "LHNetClient.h"
#import "ApiBuilder.h"
#import "NFSNSString+URL.h"

const NSString* testURL = @"topic/recommend/bs0315-iphone-4.3/0-30.json?openudid=d41d8cd98f00b204e9800998ecf8427e617c93e8&appname=bs0315&asid=D39B26EB-4CB0-4789-85AD-B2E8F4A27BD1&client=iphone&device=iPhone%205&from=ios&jbk=0&mac=&market=&openudid=d41d8cd98f00b204e9800998ecf8427e617c93e8&udid=&ver=4.3";

@interface LHNetEngine()
@property(atomic, strong)NSMutableDictionary* modifyTimeStampDic;
@end
@implementation LHNetEngine

+ (LHNetEngine*)sharedInstance {
    static LHNetEngine *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[LHNetEngine alloc] init];
        
    });
    return _shared;

}

-(instancetype)init{
    self = [super init];
    if (self) {
        _modifyTimeStampDic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

+ (NSURLSessionDataTask *)getByUrl:(NSString *)url withBlock:(void (^)(NSDictionary *result, NSError *error))block{
    url = [NSString stringWithFormat:@"%@%@", [LHNetClient mainHostURL], url];
    DLog(@"GET URL ---------------------- %@", url);

    
    // 初始化Request
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [[LHNetClient sharedClient].requestSerializer requestWithMethod:@"GET" URLString:url parameters:nil error:&serializationError];
    if (serializationError) {
        if (block) {
            dispatch_async([LHNetClient sharedClient].completionQueue ?: dispatch_get_main_queue(), ^{
                block(nil, serializationError);
            });
        }
        return nil;
    }
    
    // 加入Header
    // 写入本地记录的上次请求数据返回的Last-Modified时间到Header中的If-Modified-Since
    NSString* urlNoEncrypt = [[LHNetEngine sharedInstance] removeEncryptQuery:url];
    NSString* urlMD5 = [urlNoEncrypt md5String];
    NSString* timeRecord = (NSString* )[[LHNetEngine sharedInstance].modifyTimeStampDic objectForKey:urlMD5];
    NSURLRequest* requestNoEncript = [NSURLRequest requestWithURL:[NSURL URLWithString:urlNoEncrypt]];
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:requestNoEncript];
    // 本地有请求的旧缓存，且有modify时间的时候才插入If-Modified-Since
    if ([cachedResponse isKindOfClass:[NSCachedURLResponse class]] &&
        [timeRecord isKindOfClass:[NSString class]] &&
        timeRecord.length > 0) {
//        [[LHNetClient sharedClient].requestSerializer setValue:timeRecord forHTTPHeaderField:@"If-Modified-Since"];
        [request addValue:timeRecord forHTTPHeaderField:@"If-Modified-Since"];
    }
    
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [[LHNetClient sharedClient] dataTaskWithRequest:request
                          uploadProgress:nil
                        downloadProgress:nil
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                                [[LHNetEngine sharedInstance] processFailed:dataTask withError:error withComplition:block];
                           } else {
                                [[LHNetEngine sharedInstance] processSuccess:dataTask withResponseData:responseObject withComplition:block];
                           }
                       }];
    
    [dataTask resume];
    
    return dataTask;
    
    
    /*
    NSURLSessionDataTask* rttask = [[LHNetClient sharedClient] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseData) {
        [wself processSuccess:task withResponseData:responseData withComplition:block];
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [wself processFailed:task withError:error withComplition:block];
    }];
     
    return rttask;
    */
}

-(void)processSuccess:(NSURLSessionDataTask *__unused) task withResponseData:(id)responseData withComplition:(void (^)(NSDictionary *result, NSError *error))block{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
    if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        
        NSString* urlNoEncrypt = [[LHNetEngine sharedInstance] removeEncryptQuery:task.originalRequest.URL.absoluteString];
        NSURLRequest* requestNoEncript = [NSURLRequest requestWithURL:[NSURL URLWithString:urlNoEncrypt]];
        
        // 当返回304，填充200时候本地NSURLCache缓存的数据
        if (200 == httpResponse.statusCode) {
            NSData *toCacheData = [NSKeyedArchiver archivedDataWithRootObject:responseData];
            
            NSCachedURLResponse* response = [[NSCachedURLResponse alloc] initWithResponse:task.response data:toCacheData];
            
            [[NSURLCache sharedURLCache] storeCachedResponse:response forRequest:requestNoEncript];
        }
        // 记录请求返回response中Header的Last-Modified时间到本地
        NSDictionary* headerDic = httpResponse.allHeaderFields;
        NSString* timeStamp = headerDic[@"Last-Modified"];
        NSString* urlMD5 = [urlNoEncrypt md5String];
        NSMutableDictionary* dic = [LHNetEngine sharedInstance].modifyTimeStampDic;
        [dic setValue:timeStamp forKey:urlMD5];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary* result = responseData ;
        if (block) {
            block(result, nil);
        }
    });
}

-(void)processFailed:(NSURLSessionDataTask *__unused) task withError:(NSError *)error withComplition:(void (^)(NSDictionary *result, NSError *error))block{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
    
    NSDictionary *resultDic = [NSDictionary dictionary];
    
    if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        NSString* urlNoEncrypt = [[LHNetEngine sharedInstance] removeEncryptQuery:task.originalRequest.URL.absoluteString];
        NSURLRequest* requestNoEncript = [NSURLRequest requestWithURL:[NSURL URLWithString:urlNoEncrypt]];
        
        // 当返回304，填充200时候本地NSURLCache缓存的数据
        if (304 == httpResponse.statusCode) {
            DLog(@"*-*-*-*-*-*-*-* statusCode = 304, %@",task.originalRequest.URL.absoluteString);
            NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:requestNoEncript];
            if ([cachedResponse isKindOfClass:[NSCachedURLResponse class]]) {
                NSData* cachedData = cachedResponse.data;
                // 304,如果有缓存数据，当做成功返回
                resultDic = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:cachedData];
                if([resultDic isKindOfClass:[NSDictionary class]]){
                    error = nil;
                }
            }
        }
    }
    if (block) {
        if (error == nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (block) {
                    block(resultDic, nil);
                }
            });
        }else{
            if (block) {
                block(resultDic, error);
            }
        }
    }
}

- (NSString*)removeEncryptQuery:(NSString*)url {
    
    NSMutableString * dataString = [NSMutableString stringWithString:url] ;
    if (0 < dataString.length) {
        [dataString replaceOccurrencesOfString:@"key=.*?&" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, dataString.length)];
        [dataString replaceOccurrencesOfString:@"e=.*?&" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, dataString.length)];
        [dataString replaceOccurrencesOfString:@"&key=.*" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, dataString.length)];
        [dataString replaceOccurrencesOfString:@"&e=.*" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, dataString.length)];
        return dataString;
    }
    return nil;
}



#pragma mark - 一级列表

// TEST
+ (NSURLSessionDataTask *)TESTgetByUrl:(NSString *)url withBlock:(void (^)(NSDictionary *result, NSError *error))block{
    return [[LHNetClient sharedClient] testGetDataWithBlock:^(NSDictionary *result, NSError *error) {
        if(block){
            block(result, nil);
        }
    }];
}
//分类文章列表
+(NSURLSessionDataTask *)getTopicListDataByCategory:(NSInteger)cate pageIndex:(NSInteger)p completion:(void (^)(NSDictionary *result, NSError *error))block{
    
    NSDictionary* biz = @{@"category" : [NSNumber numberWithInteger:cate],
                          @"p"        : [NSNumber numberWithInteger:p]};

    NSString * url = [ApiBuilder topicListData:biz];
    return [LHNetEngine TESTgetByUrl:url withBlock:block];
}

@end
