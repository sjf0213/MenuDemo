//
//  HomeViewController.m
//  MenuDemo
//
//  Created by 宋炬峰 on 2016/11/8.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeScrollMenu.h"
#import "TopicCategoryHelper.h"
#import "ListViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet HomeScrollMenu *homeMenu;
@property (strong, nonatomic) UIScrollView *mainScroll;
@property (assign, nonatomic) BOOL appearedOnce;

@property (strong, nonatomic) NSMutableArray* listControllerArr;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appearedOnce  = NO;
    
    NSInteger n = self.homeMenu.itemCount;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.listControllerArr = [NSMutableArray arrayWithCapacity:n];
    for (int i = 0; i < n; ++i) {
        [self.listControllerArr addObject:@""];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 104)];
    [self.view addSubview:self.mainScroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (NO == self.appearedOnce) {
        
        NSInteger n = self.homeMenu.itemCount;
        self.mainScroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * n, [UIScreen mainScreen].bounds.size.height - 64 - 40);
        self.mainScroll.backgroundColor = [UIColor colorWithRed:0xf1/255.0 green:0xf2/255.0 blue:0xf8/255.0 alpha:1.0];
        self.mainScroll.pagingEnabled = YES;
        self.mainScroll.showsHorizontalScrollIndicator = YES;
        self.mainScroll.showsVerticalScrollIndicator = YES;
        self.mainScroll.delegate = self;
        __weak typeof(self) wself = self;
        self.homeMenu.tapItemHandler = ^(TopicCategoryModel* model){
            [wself.mainScroll setContentOffset:CGPointMake(model.index * [UIScreen mainScreen].bounds.size.width, 0)  animated:NO];
            
        };
        self.appearedOnce = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 初始化首页列表
    [self addListToPosIndex:0];
}

#pragma mark - 引用属性

-(ListViewController*)ListForIndex:(NSInteger)k{
    if (k < self.listControllerArr.count) {
        return self.listControllerArr[k];
    }
    return nil;
}

-(void)setListController:(UIViewController*)controller ForIndex:(NSInteger)k{
    self.listControllerArr[k] = controller;
}

#pragma mark - 逻辑

-(void)moveFocusToListViewByIndex:(NSInteger)index{
    
    // 生成列表视图
    [self addListToPosIndex:index];
    
    // 对于已经不可见的列表视图做相应的处理
}

-(void)addListToPosIndex:(NSInteger)index{
    id list = [self ListForIndex:index];
    if ([list isKindOfClass:[ListViewController class]]) {
        return;
    }
    
    // 创建TableView
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = self.mainScroll.bounds.size.height;
    CGRect rc = CGRectMake(index * w, 0, w, h);
    
    ListViewController* listController = [[ListViewController alloc] initWithFrame:rc];
    [self.mainScroll addSubview:listController.view];
    [self setListController:listController ForIndex:index];
    [self addChildViewController:listController];
    
    TopicCategoryModel* category = [self.homeMenu categoryModelInPosition:index];
    [listController setCategoryId:category.categoryId];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.mainScroll) {
        CGFloat x = self.mainScroll.contentOffset.x;
        CGFloat f = x / self.mainScroll.bounds.size.width;
        [self.homeMenu setCurrFloatPos:f];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.mainScroll) {
        CGFloat x = self.mainScroll.contentOffset.x;
        NSInteger n = x / self.mainScroll.bounds.size.width;
        // 改变上面的一级菜单
        [self.homeMenu setCurrSelected:n];
        // 创建TableView
        [self moveFocusToListViewByIndex:n];
    }
}



@end
