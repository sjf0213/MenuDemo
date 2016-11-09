//
//  LHNetClient.m
//  Lahong
//
//  Created by 宋炬峰 on 16/9/19.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "LHNetClient.h"


@implementation LHNetClient

+ (instancetype)sharedClient {
    static LHNetClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 15;
        _sharedClient = [[LHNetClient alloc] initWithSessionConfiguration:sessionConfig];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sharedClient.requestSerializer setTimeoutInterval:15];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return _sharedClient;
}

+(NSString*)mainHostURL{
    return [NSString stringWithFormat:@"http://%@/", LH_HOST];
}

// test
-(NSURLSessionDataTask* )testGetDataWithBlock:(void (^)(NSDictionary *result, NSError *error))block{
    [self performSelector:@selector(dataWithBlock:) withObject:block afterDelay:0.5];
    return [NSURLSessionDataTask new];
}

-(void)dataWithBlock:(void (^)(NSDictionary *result, NSError *error))block{
    
    
    NSDictionary* art1 =@{@"artid":@"1",
                          @"createtime":@"[createtime]",
                          @"begintime":@"[begintime]",    // 文章上架时间
                          @"endtime":@"",
                          @"type":@"1",    // 文章类型,1纯文字, 2静态图片, 3 gif图片, 4视频, 5图文混排
                          @"tags":@[@"1", @"123", @"12345", @"112",  @"22222",@"33333", @"1111111111"],
                          @"title":@"[标题11111]",
                          @"content":@"[内容:前几天坐飞机，飞行平稳后，我去洗手间，推开门赫然发现一个女生在里面，她生气的说：你进来怎么不敲门呀？我断然退出，然后敲了敲门问：我可以进来吗？里面喊：滚！……我再也不相信女人了。]",
                          @"picurl":@"http://wimg.spriteapp.cn/picture/2016/0918/57de42c53d0c6__b_48.jpg",
                          @"picsizew":@854,
                          @"picsizeh":@480,
                          @"videourl":@"[视频链接]",
                          @"videoduration":@"[视频持续时长]",
                          @"previewurl":@"http://wimg.spriteapp.cn/picture/2016/0918/57de42c53d0c6__b_48.jpg",
                          @"previewsizew":@854,
                          @"previewsizeh":@480,
                          @"likenum":@"5",
                          @"videoplaynum":@"[视频播放次数]",
                          @"sharenum":@"[文章分享数]"};
    
    NSDictionary* art2 =@{@"artid":@"2",
                          @"createtime":@"[createtime]",
                          @"begintime":@"[begintime]",    // 文章上架时间
                          @"endtime":@"",
                          @"type":@"2",    // 文章类型,1纯文字, 2静态图片, 3 gif图片, 4视频, 5图文混排
                          @"tags":@[@"1", @"123", @"12345", @"112",  @"22222",@"33333", @"2222222222"],
                          @"title":@"[标题222222222]",
                          @"content":@"[内容22222222222222]",
                          @"picurl":@"http://wimg.spriteapp.cn/picture/2016/0918/57de42c53d0c6__b_48.jpg",
                          @"picsizew":@300,
                          @"picsizeh":@200,
                          @"videourl":@"[视频链接]",
                          @"videoduration":@"[视频持续时长]",
                          @"previewurl":@"[预览图url]",
                          @"previewsizew":@300,
                          @"previewsizeh":@200,
                          @"likenum":@"666",
                          @"videoplaynum":@"[视频播放次数]",
                          @"sharenum":@"666"};
    NSDictionary* art3 =@{@"artid":@"2",
                          @"createtime":@"[createtime]",
                          @"begintime":@"[begintime]",    // 文章上架时间
                          @"endtime":@"",
                          @"type":@"3",    // 文章类型,1纯文字, 2静态图片, 3 gif图片, 4视频, 5图文混排
                          @"tags":@[@"1", @"123", @"12345", @"112",  @"22222",@"33333", @"2222222222"],
                          @"title":@"[标题222222222]",
                          @"content":@"[内容22222222222222]",
                          @"picurl":@"http://wimg.spriteapp.cn/ugc/2016/09/25/57e6a83de4453.gif",
                          @"picsizew":@300,
                          @"picsizeh":@200,
                          @"videourl":@"[视频链接]",
                          @"videoduration":@"[视频持续时长]",
                          @"previewurl":@"[预览图url]",
                          @"previewsizew":@300,
                          @"previewsizeh":@200,
                          @"likenum":@"666",
                          @"videoplaynum":@"[视频播放次数]",
                          @"sharenum":@"666"};
    
    NSDictionary* art4 =@{@"artid":@"3",
                          @"createtime":@"[createtime]",
                          @"begintime":@"[begintime]",    // 文章上架时间
                          @"endtime":@"",
                          @"type":@"4",    // 文章类型,1纯文字, 2静态图片, 3 gif图片, 4视频, 5图文混排
                          @"tags":@[@"1", @"123", @"12345", @"112",  @"22222",@"33333", @"33333333333"],
                          @"title":@"[标题]",
                          @"content":@"[内容]",
                          @"picurl":@"[图片url]",
                          @"picsizew":@300,
                          @"picsizeh":@200,
                          @"videourl":@"http://172.18.1.221/6fb4a156-7f1d-11e6-8216-d4ae5296039d_wpd.mp4",
                          @"videoduration":@"03:28",
                          @"previewurl":@"http://wimg.spriteapp.cn/picture/2016/0918/57de42c53d0c6__b_48.jpg",
                          @"previewsizew":@300,
                          @"previewsizeh":@200,
                          @"likenum":@"77777",
                          @"videoplaynum":@"999",
                          @"sharenum":@"77777"};
    NSDictionary* art5 =@{@"artid":@"3",
                          @"createtime":@"[createtime]",
                          @"begintime":@"[begintime]",    // 文章上架时间
                          @"endtime":@"",
                          @"type":@"5",    // 文章类型,1纯文字, 2静态图片, 3 gif图片, 4视频, 5图文混排
                          @"tags":@[@"1", @"123", @"12345", @"112",  @"22222",@"33333", @"33333333333"],
                          @"title":@"[标题]",
                          @"content":@"&lt;p&gt;图文混排&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;http://downmag2.app-sage.com/weather/information/icon/20160923031006_45834.jpg&quot; alt=&quot;&quot; /&gt;&lt;/p&gt;",
                          @"picurl":@"http://wimg.spriteapp.cn/picture/2016/0918/57de42c53d0c6__b_48.jpg",
                          @"picsizew":@300,
                          @"picsizeh":@200,
                          @"videourl":@"http://is.snssdk.com/neihan/video/playback/?video_id=8f845c811bc5451da8293dd42a673d68&quality=360p&line=0&is_gif=0",
                          @"videoduration":@"03:28",
                          @"previewurl":@"http://wimg.spriteapp.cn/picture/2016/0918/57de42c53d0c6__b_48.jpg",
                          @"previewsizew":@300,
                          @"previewsizeh":@200,
                          @"likenum":@"77777",
                          @"videoplaynum":@"999",
                          @"sharenum":@"77777"};
    NSDictionary* art6 =@{@"artid":@"3",
                          @"createtime":@"[createtime]",
                          @"begintime":@"[begintime]",    // 文章上架时间
                          @"endtime":@"",
                          @"type":@"2",    // 文章类型,1纯文字, 2静态图片, 3 gif图片, 4视频, 5图文混排
                          @"tags":@[@"1", @"123", @"12345", @"112",  @"22222",@"33333", @"33333333333"],
                          @"title":@"[标题]",
                          @"content":@"&lt;p&gt;图文混排&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;http://downmag2.app-sage.com/weather/information/icon/20160923031006_45834.jpg&quot; alt=&quot;&quot; /&gt;&lt;/p&gt;",
                          @"picurl":@"http://ww2.sinaimg.cn/bmiddle/c1e8ffd5jw1f7zwo615abj20cp1qcdj2.jpg",
                          @"picsizew":@220,
                          @"picsizeh":@1080.5,
                          @"videourl":@"http://is.snssdk.com/neihan/video/playback/?video_id=8f845c811bc5451da8293dd42a673d68&quality=360p&line=0&is_gif=0",
                          @"videoduration":@"03:28",
                          @"previewurl":@"http://ww4.sinaimg.cn/bmiddle/c1e8ffd5jw1f7zu6vz1ivj20goobgkjl.jpg",
                          @"previewsizew":@300,
                          @"previewsizeh":@200,
                          @"likenum":@"77777",
                          @"videoplaynum":@"999",
                          @"sharenum":@"77777"};
    
    NSArray* list = @[art1, art2, art3, art4, art5, art6];
    
    NSDictionary* v = @{@"totle":@"100",
                        @"count": @"15",
                        @"articlelist":list};
    
    NSDictionary* dic = @{@"c":@"200",
                          @"v":v};

    
    if (block) {
        block(dic, nil);
    }
}
@end
