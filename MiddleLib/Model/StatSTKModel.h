//
//  StatSTKModel.h
//  GSGoldenSea
//
//  Created by frank weng on 17/2/24.
//  Copyright © 2017年 frank weng. All rights reserved.
//

#import "STKModel.h"

@interface StatSTKModel : STKModel

@property (nonatomic, assign) CGFloat lastClose;
@property (nonatomic, assign) CGFloat DVValue5D; //倒计
@property (nonatomic, assign) CGFloat DVValue20D;
@property (nonatomic, assign) CGFloat DVValuePoint1; //one day - another day
@property (nonatomic, assign) CGFloat DVValuePoint2; //one day - another day

@end
