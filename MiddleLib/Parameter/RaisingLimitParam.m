//
//  RaisingLimitParam.m
//  GSGoldenSea
//
//  Created by frank weng on 16-8-17.
//  Copyright (c) 2016年 frank weng. All rights reserved.
//

#import "RaisingLimitParam.h"

@implementation RaisingLimitParam

SINGLETON_GENERATOR(RaisingLimitParam, shareInstance);


-(id)init
{
    if(self = [super init]){
        self.durationAfterBuy = kInvalidData_Base+1;
        self.buyPercent = kInvalidData_Base+1;
    }
    
    return self;
}


@end
