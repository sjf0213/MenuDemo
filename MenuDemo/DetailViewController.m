//
//  DetailViewController.m
//  MenuDemo
//
//  Created by 宋炬峰 on 2016/11/11.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>

@interface DetailViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *mainWV;
@property (nonatomic, assign) BOOL appearedOnce;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.mainWV = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.mainWV.navigationDelegate = self;
    self.mainWV.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    DLog(@".........viewDidLoad....frame = %@", NSStringFromCGRect(self.view.frame));
    [self.view addSubview:self.mainWV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    self.mainWV.frame = self.view.bounds;
    DLog(@".........viewDidLayoutSubviews....frame = %@", NSStringFromCGRect(self.view.frame));
}

-(void)setUrl:(NSURL *)url{
    _url = [url copy];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (NO == self.appearedOnce) {
        NSURL* url = self.url;
        if ([url isKindOfClass:[NSURL class]]) {
            NSURLRequest* request = [NSURLRequest requestWithURL:url];
            [self.mainWV loadRequest:request];
        }
    }
}


@end
