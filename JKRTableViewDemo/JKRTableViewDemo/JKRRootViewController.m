//
//  JKRRootViewController.m
//  JKRTableViewDemo
//
//  Created by Joker on 2017/4/6.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRRootViewController.h"
#import "JKRTableView.h"

@interface JKRRootViewController ()<JKRTableViewDelegate, JKRTableViewDataSource>

@property (nonatomic, strong) JKRTableView *tableView;

@end

@implementation JKRRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(JKRTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(JKRTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(JKRTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

- (JKRTableView *)tableView {
    if (!_tableView) {
        _tableView = [[JKRTableView alloc] init];
        _tableView.jkr_delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
