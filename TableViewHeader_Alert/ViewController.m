//
//  ViewController.m
//  TableViewHeader_Alert
//
//  Created by Yuki on 2020/11/27.
//  Copyright © 2020 Tzl. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh.h>
#import <Masonry.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/**  列表个数  **/
@property (nonatomic , assign)NSInteger  numerOfRows;

/**  tipView  **/
@property (nonatomic , strong)UIView  *tipView;
/** 列表  **/
@property (nonatomic , strong)UITableView  *mainList;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"下拉刷新试试";
    self.view.backgroundColor = UIColor.whiteColor;
    self.numerOfRows = 10;
    
    ///创建界面
    [self buildUI];
}


///创建界面
- (void)buildUI{
    [self.view addSubview:self.mainList];
    [self.mainList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    
    __weak typeof(self)weakSelf = self;
    self.mainList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshList];
    }];
}


#pragma mark - --------- 刷新列表  ---------
- (void)refreshList{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.numerOfRows = self.numerOfRows + 10;
        [self.mainList reloadData];
        [self reChangeTableView];
    });
}
///修改头部
- (void)reChangeTableView{
    [self.mainList.mj_header addSubview:self.tipView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mainList.mj_header endRefreshing];
        __weak typeof(self)weakSelf = self;
        self.mainList.mj_header.endRefreshingCompletionBlock = ^{
            [weakSelf.tipView removeFromSuperview];
        };
    });
}

#pragma mark - --------- 列表代理  ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numerOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    return cell;
}


#pragma mark - --------- lazy  ---------
///创建列表
- (UITableView *)mainList{
    if (!_mainList) {
        _mainList = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainList.delegate = self;
        _mainList.dataSource = self;
        _mainList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _mainList;
}


///tipView
- (UIView *)tipView{
    if (!_tipView) {
        _tipView = [[UIView alloc]init];
        _tipView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 54);
        _tipView.backgroundColor = UIColor.redColor;
    }
    return _tipView;
}

@end
