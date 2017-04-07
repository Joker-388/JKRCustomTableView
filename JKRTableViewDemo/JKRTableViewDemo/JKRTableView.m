
//
//  JKRTableView.m
//  JKRTableViewDemo
//
//  Created by Joker on 2017/4/6.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JKRTableView.h"
#import "JKRRowInfoModel.h"

@interface JKRTableView ()

@property (nonatomic, strong) NSMutableArray<__kindof UITableViewCell *> *reuseCellPool; // cell缓存池,待重用
@property (nonatomic, strong) NSMutableArray<JKRRowInfoModel *> *rowInfoArray;           // cell位置池
@property (nonatomic, strong) NSMutableDictionary *visibleCellPool;                      // 正在展示的cell

@end

@implementation JKRTableView

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat startY = (self.contentOffset.y < 0) ? 0 : self.contentOffset.y; // 当前tableView顶部的坐标
    // 如果当前滚动的Y+tableView的高度大于tableView的contentSize的高度，证明滚动到了最底部，endY等于contentSize的高度
    // 如果当前滚动的Y+tableView的高度小于tableView的contentSize的高度，还么有滚动到最底部，endY等于startY的tableView的高度
    CGFloat endY = (startY + self.frame.size.height) > self.contentSize.height ? self.contentSize.height : startY + self.frame.size.height; // 当前tableView底部的坐标。
    
    // 顶部cell的index
    NSInteger startIndex = [self binarySearchIndexWithTopPosition:startY];
    // 底部cell的index
    NSInteger endIndex = [self binarySearchIndexWithTopPosition:endY];
    
    NSLog(@"startIndex:%zd - endIndex:%zd", startIndex, endIndex);

    // 当前展示的cell的范围
    NSRange visibleCellRange = NSMakeRange(startIndex, endIndex-startIndex + 1);

    for (NSInteger i = visibleCellRange.location; i < visibleCellRange.location + visibleCellRange.length; i++) {
        UITableViewCell *cell = self.visibleCellPool[@(i)];
        if (!cell) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            cell = [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
            [self.visibleCellPool setObject:cell forKey:@(i)];
            [self.reuseCellPool removeObject:cell];
        }
        JKRRowInfoModel *rowInfoModel = self.rowInfoArray[i];
        cell.frame = CGRectMake(0, rowInfoModel.originY, self.frame.size.width, rowInfoModel.sizeHeight);
        if (![cell superview]) {
            [self addSubview:cell];
        }
    }
    
    NSArray *visibleCellKeys = [self.visibleCellPool allKeys];
    for (int i = 0; i < visibleCellKeys.count; i++) {
        NSInteger indexKey = [visibleCellKeys[i] integerValue];
        if (indexKey < visibleCellRange.location || indexKey > visibleCellRange.location + visibleCellRange.length) {
            [self.reuseCellPool addObject:self.visibleCellPool[@(indexKey)]];
            [self.visibleCellPool removeObjectForKey:@(indexKey)];
        }
    }
    
    NSLog(@"%zd -- %zd -- %zd", self.visibleCellPool.count, self.reuseCellPool.count, self.rowInfoArray.count);
}

-(UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    if (self.reuseCellPool.count == 0) return nil;
    for (unsigned int i = 0; i < self.reuseCellPool.count; i++) {
        if ([self.reuseCellPool[i].reuseIdentifier isEqual:identifier]) return self.reuseCellPool[i];
    }
    return nil;
}

- (void)reloadData {
    [self countRowPosition];
    [self setNeedsLayout];
}

- (NSRange)visibleRowRangeWithStart:(CGFloat)startY end:(CGFloat)endY startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    for (NSInteger i = 0; i < self.rowInfoArray.count; i++) {
        JKRRowInfoModel *rowInfo = self.rowInfoArray[i];
        if (startIndex == -1) {
            if (startY >= rowInfo.originY && startY < rowInfo.originY + rowInfo.sizeHeight) {
                startIndex = i;
            }
        } else {
            if (endY >= rowInfo.originY && endY < rowInfo.originY + rowInfo.sizeHeight) {
                endIndex = i;
                break;
            }
        }
    }
    return NSMakeRange(startIndex, endIndex - startIndex + 1);
}

- (void)countRowPosition {
    [self.rowInfoArray removeAllObjects];
    CGFloat addUpHigh = 0;
    for (int i = 0; i < [self.dataSource tableView:self numberOfRowsInSection:0]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        CGFloat cellHight = [self.jkr_delegate tableView:self heightForRowAtIndexPath:path];
        JKRRowInfoModel *rowInfo = [[JKRRowInfoModel alloc] init];
        rowInfo.originY = addUpHigh;
        rowInfo.sizeHeight = cellHight;
        [self.rowInfoArray addObject:rowInfo];
        addUpHigh += cellHight;
    }
    [self setContentSize:CGSizeMake(self.frame.size.width, addUpHigh)];
}

- (NSInteger)binarySearchIndexWithTopPosition:(CGFloat)topPosition {
    NSInteger min = 0;
    NSInteger max = self.rowInfoArray.count - 1;
    NSInteger mid;
    mid = min + (max - min)/2;
    while (min < max) {
        mid = min + (max - min) / 2;
        JKRRowInfoModel *midModel = self.rowInfoArray[mid];
        if (topPosition >= midModel.originY && topPosition < midModel.originY + midModel.sizeHeight) {
            return mid;
        } else if (topPosition < midModel.originY) {
            max = mid;
            if (max - mid == 1) {
                return min;
            }
        } else {
            min = mid;
            if (max - min == 1) {
                return max;
            }
        }
    }
    return -1;
}

- (NSMutableArray<UITableViewCell *> *)reuseCellPool {
    if (!_reuseCellPool) {
        _reuseCellPool = [NSMutableArray array];
    }
    return _reuseCellPool;
}

- (NSMutableArray<JKRRowInfoModel *> *)rowInfoArray {
    if (!_rowInfoArray) {
        _rowInfoArray = [NSMutableArray array];
    }
    return _rowInfoArray;
}

- (NSMutableDictionary *)visibleCellPool {
    if (!_visibleCellPool) {
        _visibleCellPool = [NSMutableDictionary dictionary];
    }
    return _visibleCellPool;
}

@end
