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
    
    [[HYLog shareInstance] enableLog];
    
//    KeyTimeObj* keyTimeObj = [[KeyTimeObj alloc]init];

    GSBaseResult* reslut = [GSObjMgr shareInstance].mgr.reslut;
    
    NSArray* stkArray = [GSObjMgr shareInstance].mgr.realStkRangeArray;
    
    long j=0;
    for(long i = 0; i<[stkArray count]; i++){
        NSString* stk = [stkArray objectAtIndex:i];
        
        NSMutableArray* paramArray = [reslut paramArrayWithSymbol:stk];
        NSArray* arrayUsed = [self reOrderParamArray:paramArray];
        RaisingLimitParam* ele = [arrayUsed objectAtIndex:0];
        if(ele.totalCount == 0){
            continue;
        }
//        SMLog(@"\nNo.(%d)- Conditon:  DESTDVVALUE(%.2f), duration(%d)  Result:avgVal(%.2f),totalCount(%d) ",j++,  ele.destDVValue,  ele.durationAfterBuy, ele.avgS2BDVValue ,ele.totalCount);
        SMLog(@" ");
        [self logAllResultWithParam:ele];
        
    }
    
    
    [[HYLog shareInstance] disableLog];
    
    SMLog(@"<--end of analysisAndLogtoFile");
}



-(void)logWithParam:(GSBaseParam*)param isForSel:(BOOL)isForSel;
{
    NSArray* resultArray = param.resultArray;
    long totalCount = param.totalCount;
    
    //calulate percent firstly
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    for(long i=0; i<[resultArray count]; i++){
        tmpArray = [resultArray objectAtIndex:i];
        if([tmpArray count] == 0){
            continue;
        }
        percent = [tmpArray count]*100.f/totalCount;
        
//        SMLog(@"index(%ld), percent(%.2f)  count(%d) ", i, percent,[tmpArray count]);
        
        for (KDataModel* kData in tmpArray) {
            TradeDebugData* tradeDbg = kData.tradeDbg;
            BOOL isT1Red = [tradeDbg.T1Data isRed];
            CGFloat dvT1Open = tradeDbg.T1Data.open/tradeDbg.T0Data.close;
            CGFloat dvT0Open = tradeDbg.T0Data.open/tradeDbg.TP1Data.close;
            CGFloat dvT0Close = tradeDbg.T0Data.close/tradeDbg.TP1Data.close;
            CGFloat dvT0High = tradeDbg.T0Data.high/tradeDbg.TP1Data.close;
            CGFloat dvT0Low = tradeDbg.T0Data.low/tradeDbg.TP1Data.close;
            SMLog(@"%@ TBuyData:%ld, TSellData:%ld, dvSelltoBuy:%.2f, dvT0Open:%.3f,dvT0Close:%.3f,dvT0High:%.3f,dvT0Low:%.3f,  ",kData.stkID, tradeDbg.TBuyData.time,tradeDbg.TSellData.time,tradeDbg.dvSelltoBuy,
                  dvT0Open,dvT0Close,dvT0High,dvT0Low);
//            SMLog(@"%@ TBuyData:%ld, TSellData:%ld, dvSelltoBuy:%.2f, dvT0Open:%.3f,dvT0Close:%.3f,dvT0High:%.3f,dvT0Low:%.3f, dvT1Open:%.2f, isT1Red:%@, ",kData.stkID, tradeDbg.TBuyData.time,tradeDbg.TSellData.time,tradeDbg.dvSelltoBuy,
//                  dvT0Open,dvT0Close,dvT0High,dvT0Low,
//                  dvT1Open,isT1Red?@"Yes":@"No");
        }
    }
}



//for ref.
//-(void)analysisAndLogtoFile;
//{
//    
//    [[HYLog shareInstance] enableLog];
//    
//    //    KeyTimeObj* keyTimeObj = [[KeyTimeObj alloc]init];
//    
//    GSBaseResult* reslut = [GSObjMgr shareInstance].mgr.reslut;
//    
//    NSArray* stkArray = [GSObjMgr shareInstance].mgr.realStkRangeArray;
//    
//    for(long i = 0; i<[stkArray count]; i++){
//        NSString* stk = [stkArray objectAtIndex:i];
//        
//        NSMutableArray* paramArray = [reslut paramArrayWithSymbol:stk];
//        NSArray* arrayUsed = [self reOrderParamArray:paramArray];
//        
//        //        SMLog(@"---detail report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate);
//        for (long i=0; i<[arrayUsed count]; i++) {
//            RaisingLimitParam* ele = [arrayUsed objectAtIndex:i];
//            if(ele.totalCount == 0){
//                continue;
//            }
//            SMLog(@"No.(%d)- Conditon: LastLimit(%d), BUYPERCENT(%.2f), DESTDVVALUE(%.2f), duration(%d)  Result:avgVal(%.2f),totalCount(%d) ",i, ele.daysAfterLastLimit,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.avgS2BDVValue ,ele.totalCount);
//            [self logAllResultWithParam:ele];
//        }
//        
//        
//        //        SMLog(@"---summary report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate );
//        //        for (long i=0; i<[arrayUsed count]; i++) {
//        //            RaisingLimitParam* ele = [arrayUsed objectAtIndex:i];
//        //            SMLog(@"No.(%d)- Conditon: LastLimit(%d),buyIndex(%d-%d) BUYPERCENT(%.2f), DESTDVVALUE(%.2f), duration(%d)  Result:totalAvgVal(%.2f),totalCount(%d), SelCount(%d), selAvg(%.2f) ",i, ele.daysAfterLastLimit,ele.buyStartIndex,ele.buyEndIndex,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.allAvgS2BDVValue ,ele.allTotalCount,ele.selTotalCount,ele.selAvgS2BDVValue );
//        //        }
//        //
//        //        SMLog(@"\n");
//        //        SMLog(@"---detail report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate);
//        //        for (long i=0; i<[arrayUsed count]; i++) {
//        //            RaisingLimitParam* ele = [arrayUsed objectAtIndex:i];
//        //            SMLog(@"No.(%d)- Conditon: LastLimit(%d), BUYPERCENT(%.2f), DESTDVVALUE(%.2f), duration(%d)  Result:avgVal(%.2f),totalCount(%d), SelCount(%d), selAvg(%.2f) ",i, ele.daysAfterLastLimit,ele.buyPercent, ele.destDVValue,  ele.durationAfterBuy, ele.allAvgS2BDVValue ,ele.allTotalCount,ele.selTotalCount,ele.selAvgS2BDVValue );
//        //            [self logAllResultWithParam:ele];
//        //        }
//    }
//    
//    
//    [[HYLog shareInstance] disableLog];
//    
//    SMLog(@"<--end of analysisAndLogtoFile");
//}


@end
