//
//  JKRRowInfoModel.h
//  JKRTableViewDemo
//
//  Created by Joker on 2017/4/6.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKRRowInfoModel : NSObject

@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGFloat sizeHeight;

@end
