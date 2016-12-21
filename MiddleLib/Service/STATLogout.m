//
//  STATLogout.m
//  GSGoldenSea
//
//  Created by frank weng on 16/12/21.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STATLogout.h"
#import "STATAnalysisMgr.h"

@implementation STATLogout


-(NSArray*)reOrderResultArray:(NSArray*)array
{
    NSArray *resultArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        STKResult* par1 = obj1;
        STKResult* par2 = obj2;
        
        NSNumber *number1 = [NSNumber numberWithFloat: par1.avgDV];
        NSNumber *number2 = [NSNumber numberWithFloat: par2.avgDV];
        
        
        NSComparisonResult result = [number1 compare:number2];
        
        //        return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
    }];
    
    
    return resultArray;
}


-(void)analysisAndLogtoFile;
{
    
    [[HYLog shareInstance] enableLog];
    
    STATAnalysisMgr* mgr = (STATAnalysisMgr*)[GSObjMgr shareInstance].mgr;
    NSArray* resultArray = mgr.statResultArray;
    
    resultArray = [self reOrderResultArray: resultArray];

    
    //calulate percent firstly
    NSArray* tmpArray;
    for(long i=0; i<[resultArray count]; i++){
        
        STKResult* stkResult = [resultArray safeObjectAtIndex:i];
        SMLog(@"%@: avgDV:%.2f",stkResult.stkID,stkResult.avgDV);

        for (KDataModel* kData in stkResult.eleArray) {
            SMLog(@"time:%ld, dvT0:%.2f",kData.time,kData.dvDbg.dvT0.dvClose);
        }
    }
    
    
    [[HYLog shareInstance] disableLog];
    
    SMLog(@"<--end of analysisAndLogtoFile");
}


@end
