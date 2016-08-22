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
        SMLog(@"No.(%d)- Conditon: LastLimit(%d), BUYPERCENT(%.2f), DESTDVVALUE(%.2f), duration(%d)  Result:avgVal(%.2f),totalCount(%d), SelCount(%d), selVal(%2f) ",i, ele.daysAfterLastLimit,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.allAvgS2BDVValue ,ele.allTotalCount,ele.selTotalCount,ele.selTotalS2BDVValue );
    }

    SMLog(@"\n");
    SMLog(@"---detail report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate);
    for (long i=0; i<[self.paramArray count]; i++) {
        RaisingLimitParam* ele = [self.paramArray objectAtIndex:i];
        SMLog(@"No.(%d)- Conditon: LastLimit(%d), BUYPERCENT(%.2f), DESTDVVALUE(%.2f), duration(%d)  Result:avgVal(%.2f),totalCount(%d), SelCount(%d), selVal(%2f) ",i, ele.daysAfterLastLimit,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.allAvgS2BDVValue ,ele.allTotalCount,ele.selTotalCount,ele.selTotalS2BDVValue );
        [self logWithParam:ele];
    }
    
    
    [[HYLog shareInstance] disableLog];
    
    SMLog(@"<--end of analysisAndLogtoFile");
}





@end
