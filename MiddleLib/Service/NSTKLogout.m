//
//  NSTKLogout.m
//  GSGoldenSea
//
//  Created by frank weng on 16/12/19.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "NSTKLogout.h"
#import "NewStkAnalysisMgr.h"

@implementation NSTKLogout


-(NSArray*)reOrderResultArray:(NSMutableArray*)array
{
    NSArray *resultArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        KDataModel* par1 = obj1;
        KDataModel* par2 = obj2;
        
        NSNumber *number1 = [NSNumber numberWithFloat: par1.time];
        NSNumber *number2 = [NSNumber numberWithFloat: par2.time];
        
        
        NSComparisonResult result = [number1 compare:number2];
        
        //        return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
    }];
    
    
    return resultArray;
}


-(void)analysisAndLogtoFile;
{
    
    [[HYLog shareInstance] enableLog];
    
    NewStkAnalysisMgr* mgr = (NewStkAnalysisMgr*)[GSObjMgr shareInstance].mgr;
    GSBaseParam* param = mgr.NSTKparam;
    
    SMLog(@"totalCount:%ld, totalS2BDVValue:%.2f",param.totalCount, param.totalS2BDVValue);

    
    NSArray* resultArray = param.resultArray;
    
    //calulate percent firstly
    NSArray* tmpArray;
    for(long i=0; i<[resultArray count]; i++){
        tmpArray = [self reOrderResultArray: [resultArray objectAtIndex:i]];
        if([tmpArray count] == 0){
            continue;
        }
        
        for (KDataModel* kData in tmpArray) {
            TradeDebugData* tradeDbg = kData.tradeDbg;
            NSString* isOpenLimit = tradeDbg.isOpenLimit ? @"YES":@"NO";
            SMLog(@"%@ TBuyData:%ld, buyDayOpen:%.2f, dvSelltoBuy:%.2f, oneValDay:%ld, pvLow2Op:%.3f",kData.stkID, tradeDbg.TBuyData.time,tradeDbg.TBuyData.open,tradeDbg.dvSelltoBuy,tradeDbg.oneValDay, tradeDbg.pvLow2Op);

//            SMLog(@"%@ TBuyData:%ld, buyDayOpen:%.2f, dvSelltoBuy:%.2f, oneValDay:%ld, isOpenLimit:%@",kData.stkID, tradeDbg.TBuyData.time,tradeDbg.TBuyData.open,tradeDbg.dvSelltoBuy,tradeDbg.oneValDay, isOpenLimit);
        }
    }
    
    
    [[HYLog shareInstance] disableLog];
    
    SMLog(@"<--end of analysisAndLogtoFile");
}


@end
