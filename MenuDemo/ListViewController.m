//
//  ListViewController.m
//  MenuDemo
//
//  Created by 宋炬峰 on 2016/11/9.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "ListViewController.h"
#import "TopicListView.h"

@interface ListViewController ()
@property(nonatomic, strong, readwrite)TopicListView* mainView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
