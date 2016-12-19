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



-(void)analysisAndLogtoFile;
{
    
    [[HYLog shareInstance] enableLog];
    
    NewStkAnalysisMgr* mgr = (NewStkAnalysisMgr*)[GSObjMgr shareInstance].mgr;
    GSBaseParam* param = mgr.NSTKparam;
    
    SMLog(@"totalCount:%ld, totalS2BDVValue:%.2f",param.totalCount, param.totalS2BDVValue);

    
    NSArray* resultArray = param.resultArray;
    
    //calulate percent firstly
    NSMutableArray* tmpArray;
    for(long i=0; i<[resultArray count]; i++){
        tmpArray = [resultArray objectAtIndex:i];
        if([tmpArray count] == 0){
            continue;
        }
        
        for (KDataModel* kData in tmpArray) {
            TradeDebugData* tradeDbg = kData.tradeDbg;
            NSString* isOpenLimit = tradeDbg.isOpenLimit ? @"YES":@"NO";
            SMLog(@"%@ TBuyData:%ld, buyDayOpen:%.2f, dvSelltoBuy:%.2f, oneValDay:%ld, isOpenLimit:%@",kData.stkID, tradeDbg.TBuyData.time,tradeDbg.TBuyData.open,tradeDbg.dvSelltoBuy,tradeDbg.oneValDay, isOpenLimit);
                    }
    }
    
    
    [[HYLog shareInstance] disableLog];
    
    SMLog(@"<--end of analysisAndLogtoFile");
}


@end
