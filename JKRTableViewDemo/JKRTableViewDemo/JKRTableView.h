//
//  JKRTableView.h
//  JKRTableViewDemo
//
//  Created by Joker on 2017/4/6.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKRTableView;

@protocol JKRTableViewDelegate <NSObject, UIScrollViewDelegate>

@required
- (CGFloat)tableView:(JKRTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol JKRTableViewDataSource <NSObject>

@required
- (NSInteger)tableView:(JKRTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(JKRTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JKRTableView : UIScrollView

@property (nonatomic, weak) id<JKRTableViewDelegate> jkr_delegate;
@property (nonatomic, weak) id<JKRTableViewDataSource> dataSource;

- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)reloadData;

@end
