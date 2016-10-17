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
    [self reOrderParamArray];
    
    [[HYLog shareInstance] enableLog];
    
//    KeyTimeObj* keyTimeObj = [[KeyTimeObj alloc]init];

    
    NSArray* arrayUsed = self.paramArray;
    
//    SMLog(@"---summary report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate );
//    for (long i=0; i<[arrayUsed count]; i++) {
//        RaisingLimitParam* ele = [arrayUsed objectAtIndex:i];
//        SMLog(@"No.(%d)- Conditon: LastLimit(%d),buyIndex(%d-%d) BUYPERCENT(%.2f), DESTDVVALUE(%.2f), duration(%d)  Result:totalAvgVal(%.2f),totalCount(%d), SelCount(%d), selAvg(%.2f) ",i, ele.daysAfterLastLimit,ele.buyStartIndex,ele.buyEndIndex,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.allAvgS2BDVValue ,ele.allTotalCount,ele.selTotalCount,ele.selAvgS2BDVValue );
//    }
//
//    SMLog(@"\n");
//    SMLog(@"---detail report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate);
//    for (long i=0; i<[arrayUsed count]; i++) {
//        RaisingLimitParam* ele = [arrayUsed objectAtIndex:i];
//        SMLog(@"No.(%d)- Conditon: LastLimit(%d), BUYPERCENT(%.2f), DESTDVVALUE(%.2f), duration(%d)  Result:avgVal(%.2f),totalCount(%d), SelCount(%d), selAvg(%.2f) ",i, ele.daysAfterLastLimit,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.allAvgS2BDVValue ,ele.allTotalCount,ele.selTotalCount,ele.selAvgS2BDVValue );
////        [self logSelResultWithParam:ele];
//        [self logAllResultWithParam:ele];
//    }
//    
    
    [[HYLog shareInstance] disableLog];
    
    SMLog(@"<--end of analysisAndLogtoFile");
}





@end
