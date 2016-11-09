//
//  ApiBuilder.m
//  Lahong
//
//  Created by 宋炬峰 on 16/9/21.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiBuilder.h"
//#import "DeviceHelper.h"
#import "NFSNSString+URL.h"



@interface ApiBuilder ()

@property(strong,nonatomic)NSDictionary * apiData;

- (void)initApiData;

@end

@implementation ApiBuilder

static NSTimeInterval startDate = 0;
static ApiBuilder * m_Instance;

+(ApiBuilder*)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_Instance= [[ApiBuilder alloc] initSingleton];
    });
    return m_Instance;
}

-(id)init
{
    NSAssert(NO, @"Cannot create instance of Singleton");
    return nil;
}

-(id)initSingleton
{
    self = [super init];
    if(self)
    {
        [self initApiData];
    }
    return self;
}

- (void)initApiData
{
    NSMutableDictionary * finalBizData = [NSMutableDictionary dictionaryWithCapacity:5];
//    [finalBizData setObject:[DeviceHelper shareInstance].cliendTypeID forKey:@"clientid"];
    [finalBizData setObject:@"1" forKey:@"json"];
    self.apiData = finalBizData;
    startDate = [[NSDate date]timeIntervalSince1970];
}

-(void)dealloc
{
    self.apiData = nil;
}

+ (NSString *)encodeUrlString:(NSString *)url params:(NSDictionary *)dic
{
    // 基本参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    // 接口自定义参数
    if (dic) {
        [params addEntriesFromDictionary:dic];
    }
    [params addEntriesFromDictionary:[ApiBuilder shareInstance].apiData];
    
    return [url stringByAppendingQuery:params key:EncyptKey];
}

#pragma mark - biz
//应用配置
+(NSString *)appConfig:(NSDictionary*)dic{
    return [ApiBuilder encodeUrlString:@"client/appconfig" params:dic];
}
//分类文章列表
+(NSString *)topicListData:(NSDictionary*)dic{
    return [ApiBuilder encodeUrlString:@"client/article/list" params:dic];
}





@end
