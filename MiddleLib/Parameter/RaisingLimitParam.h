//
//  RaisingLimitParam.h
//  GSGoldenSea
//
//  Created by frank weng on 16-8-17.
//  Copyright (c) 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

//tbd.
@interface RaisingLimitParam : NSObject

+(RaisingLimitParam*)shareInstance;


@property (assign) long durationAfterBuy;
@property (assign) CGFloat buyPercent; //such as 0.95

@end
