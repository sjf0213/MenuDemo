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
#import "LHNetEngine.h"
#import "LHRefreshTip.h"
#import "TopicModel.h"
#import "TopicViewModel.h"
#import "TopicListCell.h"
#import "DetailViewController.h"

const NSInteger PageSize = 15;
const CGFloat   TipY = 104.0;

@interface ListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong, readwrite)TopicListView* mainView;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, strong) NSMutableArray* dataArr;
@property(nonatomic, assign) NSTimeInterval lastTopicTimeStamp;
@end

@implementation ListViewController

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        self.mainView = [[TopicListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.mainView.dataSource = self;
        self.mainView.delegate = self;
        [self.mainView registerClass:[TopicListCell class] forCellReuseIdentifier:TopicListCellIdentifier];
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    DLog(@"--------------controller v will disappear : %zd", self.categoryId);
}

#pragma mark - biz

-(void)startRequestByCategory:(NSInteger)categoryId withPageIndex:(NSInteger)p {
    __weak typeof(self) wself = self;
    __block NSInteger fetchItemCount = 0;
    // 请求话题数据
    [LHNetEngine getTopicListDataByCategory:categoryId pageIndex:p completion:^(NSDictionary *result, NSError *error) {
        // 解析数据
        if (nil == error) {
            
            fetchItemCount = [wself parseMainData:result withPageIndex:p ];
            // 刷新列表
            dispatch_async(dispatch_get_main_queue(), ^ {
                // 显示提示
                [wself showRefreshTipForNormal:fetchItemCount withRequestPageIndex:p];
                // 刷新列表
                [wself refreshTableToShow];
            });
            if (fetchItemCount > 0 && p > 1) {
                wself.pageIndex++;
            }
        }else{
            DLog(@"--error.code = %zd, description = %@", error.code, [error localizedDescription]);
            if (NO == self.notVisible) {
                [LHRefreshTip showText:@"获取数据失败" parentView:wself.view withY:TipY];
            }
            [self.mainView.mj_header endRefreshing];
            [self.mainView.mj_footer endRefreshing];
        }
    }];
    [UIView animateWithDuration:2 animations:^{
        [wself.mainView.mj_header endRefreshing];
        [wself.mainView.mj_footer endRefreshing];
    }];
}

// 解析主数据
-(NSInteger)parseMainData:(NSDictionary *)result withPageIndex:(NSInteger)p{
    //    DLog(@"------Main--------------------------- %@", result);
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSString* c = result[@"c"];
        NSDictionary* v = result[@"v"];
        NSInteger code = [c integerValue];
        if (200 == code && [v isKindOfClass:[NSDictionary class]]) {
            
            NSArray* list = v[@"articlelist"];
            if ([list isKindOfClass:[NSArray class]]) {
                
                // 得到目前已有数据
                NSMutableArray* ar = [NSMutableArray arrayWithArray:self.dataArr];
                if (NO == [ar isKindOfClass:[NSArray class]]) {
                    ar = [NSMutableArray arrayWithCapacity:PageSize];
                }
                if (p == 1){
                    [ar removeAllObjects];
                }
                
                // 加入新列表数据
                // 因为按创建时间排序，如果有新话题，则时间戳都在上次最新话题的上面
                NSTimeInterval oldTimeStamp = self.lastTopicTimeStamp;
                NSInteger newTopicCount = list.count;
                for (int i = 0; i < list.count; ++i) {
                    
                    NSDictionary* dic = list[i];
                    TopicModel* model = [[TopicModel alloc] initWithDic:dic];
                    TopicViewModel *topicVM = [[TopicViewModel alloc]init];
                    topicVM.topic = model;
                    [ar addObject:topicVM];
                    
                    if(p == 1){
                        // 根据上次刷新的最新createTime计算有多少新话题
                        if(oldTimeStamp > 0){
                            NSTimeInterval newTime = model.createTime;
                            if (newTime == oldTimeStamp) {
                                newTopicCount = i;
                            }
                        }
                        // 记录下拉刷新最新的时间戳, 供下次使用
                        if ( i == 0 ) {
                            self.lastTopicTimeStamp = model.createTime;
                        }
                    }
                }
                self.dataArr = [ar copy];
                
                // 返回得到的数据个数
                if(p == 1){
                    return newTopicCount;
                }else{
                    return list.count;
                }
            }
        }else{//非200, 保持本地内存数据，不做任何改变
            
        }
    }
    return 0;
}

-(void)showRefreshTipForNormal:(NSInteger)itemCount
          withRequestPageIndex:(NSInteger)p{
    NSString* tip = @"";
    if (self.notVisible) {
        return;
    }
    // 下拉刷新,有没有数据都提示
    if( p == 1){
        
        if (itemCount < 0){
            tip = @"获取数据失败";
        }else if (itemCount == 0) {
            tip = @"暂时没有新内容";
        }else if(itemCount > 15){
            tip = @"又获取了15+篇新内容";
        }else{
            tip = [NSString stringWithFormat:@"又获取了%zd篇新内容", itemCount];
        }
        [LHRefreshTip showText:tip parentView:self.parentViewController.view withY:TipY];
        
    }else{// 上拉加载，只有没有数据时提示
        if(itemCount > 0){
            // 正常加载分页，不提示
        }else{
            // 只有失败和没有内容要提示
            if (itemCount == 0){
                tip = @"没有更多内容了";
            }else{// fetchNormalItemCount < 0
                tip = @"获取数据失败";
            }
            [LHRefreshTip showText:tip parentView:self.parentViewController.view withY:TipY];
        }
    }
}

// 刷新列表，所有列表最终显示前都要加入广告
-(void)refreshTableToShow{
    // 刷新列表
    [self.mainView reloadData];
    [self.mainView.mj_header endRefreshing];
    [self.mainView.mj_footer endRefreshing];
}

#pragma mark - 不可见的处理
-(void)setNotVisible:(BOOL)notVisible{
    _notVisible = notVisible;
    if (notVisible) {
        [self clearWhenNotVisible];
    }
}

-(void)clearWhenNotVisible{
    DLog(@"----------clearWhenNotVisible:%zd", self.categoryId);
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if ([tableView isKindOfClass:[TopicListView class]]) {
        count = self.dataArr.count;
        if(count == 0){
            tableView.mj_footer.hidden = YES;
            self.mainView.showBg = YES;
        }else{
            tableView.mj_footer.hidden = NO;
            self.mainView.showBg = NO;
        }
    }
    DLog(@"-----------numberOfRowsInSection = %zd", count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > indexPath.row) {
        TopicViewModel* cellData = self.dataArr[indexPath.row];
        if ([cellData  isKindOfClass:[TopicViewModel class]]) {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:TopicListCellIdentifier forIndexPath:indexPath];
            if ([cell isKindOfClass:[TopicListCell class]]) {
                TopicListCell* topicCell = (TopicListCell*)cell;
                [topicCell clearData];
                [topicCell loadCellData:cellData];
                return cell;
            }
        }
    }
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController* vc = [[DetailViewController alloc] init];
    vc.url = [NSURL URLWithString:@"http://www.baidu.com"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > indexPath.row) {
        TopicViewModel* cellData = self.dataArr[indexPath.row];
        if ([cellData  isKindOfClass:[TopicViewModel class]]) {
            return [cellData totalHeight];
        }
    }
    return 0;
}
@end
