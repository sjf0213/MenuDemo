//
//  ListViewController.m
//  MenuDemo
//
//  Created by 宋炬峰 on 2016/11/9.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "ListViewController.h"
#import "TopicListView.h"
#import "MJRefresh.h"

@interface ListViewController ()
@property(nonatomic, strong, readwrite)TopicListView* mainView;
@property(nonatomic, assign)NSInteger pageIndex;
@end

@implementation ListViewController

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        self.mainView = [[TopicListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:self.mainView];
        
        
    }
    return self;
}

-(void)setCategoryId:(NSInteger)categoryId{
    __weak typeof(self) wself = self;
    self.mainView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.pageIndex = 1;
        [wself startRequestByCategory:wself.categoryId withPageIndex:1];
    }];
    self.mainView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [wself startRequestByCategory:wself.categoryId withPageIndex:(wself.pageIndex + 1)];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startRequestByCategory:(NSInteger)categoryId withPageIndex:(NSInteger)p {
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:2 animations:^{
        [wself.mainView.mj_header endRefreshing];
        [wself.mainView.mj_footer endRefreshing];
    }];
}

@end
