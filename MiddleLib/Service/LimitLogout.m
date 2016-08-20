//
//  LimitLogout.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "LimitLogout.h"
#import "GSBaseAnalysisMgr.h"
#import "RaisingLimitParam.h"

@interface LimitLogout ()

@end

@implementation LimitLogout




-(void)analysisAndLogtoFile;
{
    [super analysisAndLogtoFile];
    
    [[HYLog shareInstance] enableLog];
    
    SMLog(@"---summary report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate );
    for (long i=0; i<[self.paramArray count]; i++) {
        RaisingLimitParam* ele = [self.paramArray objectAtIndex:i];
        SMLog(@"Index(%d) - Conditon: daysAfterLastLimit(%d), buyPercent(%.2f), destDVValue(%.2f), durationAfterBuy(%d)  Result:totalCount(%d), alltotalS2BDVValue(%2f) ",i, ele.daysAfterLastLimit,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.allTotalCount,ele.allTotalS2BDVValue );
    }

    SMLog(@"\n");
    SMLog(@"---detail report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate);
    for (long i=0; i<[self.paramArray count]; i++) {
        RaisingLimitParam* ele = [self.paramArray objectAtIndex:i];
        SMLog(@"Index(%d) - Conditon: daysAfterLastLimit(%d), buyPercent(%.2f), destDVValue(%.2f), durationAfterBuy(%d)  Result:totalCount(%d), alltotalS2BDVValue(%2f) ",i, ele.daysAfterLastLimit,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.allTotalCount,ele.allTotalS2BDVValue );
        [self logWithParam:ele];
    }
    
    
    [[HYLog shareInstance] disableLog];
}

@end
