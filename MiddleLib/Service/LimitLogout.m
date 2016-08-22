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
        SMLog(@"Index(%d) - Conditon: daysAfterLastLimit(%d), BUYPERCENT(%.2f), DESTDVVALUE(%.2f), durationAfterBuy(%d)  Result:totalCount(%d), alltotalS2BDVValue(%2f) ",i, ele.daysAfterLastLimit,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.allSelTotalCount,ele.allSelTotalS2BDVValue );
    }

    SMLog(@"\n");
    SMLog(@"---detail report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate);
    for (long i=0; i<[self.paramArray count]; i++) {
        RaisingLimitParam* ele = [self.paramArray objectAtIndex:i];
        SMLog(@"Index(%d) - Conditon: daysAfterLastLimit(%d), BUYPERCENT(%.2f), DESTDVVALUE(%.2f), durationAfterBuy(%d)  Result:totalCount(%d), alltotalS2BDVValue(%2f) ",i, ele.daysAfterLastLimit,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.allSelTotalCount,ele.allSelTotalS2BDVValue );
        [self logWithParam:ele];
    }
    
    
    [[HYLog shareInstance] disableLog];
    
    SMLog(@"<--end of analysisAndLogtoFile");
}





@end
