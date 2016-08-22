//
//  AvgLogout.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/22.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "AvgLogout.h"

@implementation AvgLogout


-(void)analysisAndLogtoFile;
{
    [super analysisAndLogtoFile];
    
    [[HYLog shareInstance] enableLog];
    
    //    KeyTimeObj* keyTimeObj = [[KeyTimeObj alloc]init];
    
    
    NSArray* arrayUsed = self.paramArray;
    
    SMLog(@"---summary report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate );
    for (long i=0; i<[arrayUsed count]; i++) {
        RaisingLimitParam* ele = [arrayUsed objectAtIndex:i];
        SMLog(@"No.(%d)- Conditon:  DESTDVVALUE(%.2f), duration(%d)  Result:totalAvgVal(%.2f),totalCount(%d), SelCount(%d), selAvg(%.2f) ",i, ele.destDVValue,  ele.durationAfterBuy, ele.allAvgS2BDVValue ,ele.allTotalCount,ele.selTotalCount,ele.selAvgS2BDVValue );
    }
    
    SMLog(@"\n");
    SMLog(@"---detail report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate);
    for (long i=0; i<[arrayUsed count]; i++) {
        RaisingLimitParam* ele = [arrayUsed objectAtIndex:i];
        //        [self logSelResultWithParam:ele];
        SMLog(@"No.(%d)",i);
        [self logAllResultWithParam:ele];
    }
    
    
    [[HYLog shareInstance] disableLog];
    
    SMLog(@"<--end of analysisAndLogtoFile");
}



@end
