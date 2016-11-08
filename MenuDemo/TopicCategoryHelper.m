//
//  MenuCategoryHelper.m
//  Lahong
//
//  Created by 宋炬峰 on 2016/9/28.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "TopicCategoryHelper.h"

@interface TopicCategoryModel()<NSCopying>
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, strong)NSString* categoryName;
@property(nonatomic, assign)NSInteger categoryId;
@end

@implementation TopicCategoryModel

-(instancetype)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self){
        self.categoryName = dic[@"name"];
        NSNumber* num = dic[@"id"];
        if ([num isKindOfClass:[NSNumber class]]) {
            self.categoryId = [num integerValue];
        }
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    TopicCategoryModel* obj = [super init];
    obj.index = self.index;
    obj.categoryName = [self.categoryName copy];
    obj.categoryId = self.categoryId;
    return obj;
}

@end

@implementation TopicCategoryHelper

+ (TopicCategoryHelper*)sharedInstance{
    static TopicCategoryHelper* b_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        b_instance = [[TopicCategoryHelper alloc] init];
    });
    return b_instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
       
    }
    return self;
}

-(NSArray*)getTopicCategoryList{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"HomeMenu" ofType:@"plist"];
    NSArray* basicArr = [NSArray arrayWithContentsOfFile:path];
    
    // 加入首页默认的分类
    NSMutableArray* rt = [NSMutableArray arrayWithArray:basicArr];
    [rt insertObject:@{@"name":@"发现", @"id":@0} atIndex:0];
    
    NSMutableArray* modelArr = [NSMutableArray array];
    for (int i = 0; i < rt.count; i++) {
        NSDictionary* dic = rt[i];
        TopicCategoryModel* model = [[TopicCategoryModel alloc] initWithDic:dic];
        model.index = i;
        [modelArr addObject:model];
    }
    return modelArr;
}
@end
