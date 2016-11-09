//
//  TopicModel.m
//  MenuDemo
//
//  Created by 宋炬峰 on 2016/11/9.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "TopicModel.h"

@interface TopicModel()
@property (nonatomic, copy, readwrite) NSString *ID;
@property (nonatomic, copy, readwrite) NSString *title;
@end

@implementation TopicModel

-(instancetype)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString* tempStr = dic[@"artid"];
            if ([tempStr isKindOfClass:[NSString class]] ||
                [tempStr isKindOfClass:[NSNumber class]]) {
                _ID = [NSString stringWithFormat:@"%zd", tempStr.integerValue];
            }
            _title = dic[@"title"];
        }
    }
    return self;
}
@end
