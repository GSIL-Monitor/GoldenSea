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
        self.daysAfterLastLimit = 0;
    }
    
    return self;
}



-(BOOL)isNoLimitInLastDaysBeforeIndex:(long)currIndex contentArray:(NSArray*)contentArray;
{
    if(self.daysAfterLastLimit == 0){
        return YES;
    }
    
//    long currIndex = kT0Data.tIndex;
    long lastIndex = currIndex>=self.daysAfterLastLimit ? (currIndex-self.daysAfterLastLimit):0;
    
    for(long i=lastIndex; i<currIndex; i++){
        KDataModel* tmp = [contentArray objectAtIndex:i];
        if(tmp.isLimitUp){
            return NO;
        }
    }
    
    return YES;
}


@end
