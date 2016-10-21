//
//  GSLogout.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseLogout.h"

#import "KDataModel.h"
#import "GSBaseAnalysisMgr.h"
#import "GSDataMgr.h"

#define Key_JustLogOut_All 1

@interface GSBaseLogout (){

}



@end

@implementation GSBaseLogout



-(id)init
{
    if(self = [super init]){
    }
    
    return self;
}


-(void)SimpleLogOutResult:(BOOL)isJustLogFail
{
    [self _SimpleLogOutForAll:NO isJustLogFail:isJustLogFail];
}

-(void)_SimpleLogOutForAll:(BOOL)isForAll isJustLogFail:(BOOL)isJustLogFail
{
}


//base analysis
-(void)analysisAndLogtoFile;
{
    [self _analysisAndLogtoFile:YES];
}

-(void)analysisAndLogSummry;
{
    [self _analysisAndLogtoFile:YES];

}

-(void)_analysisAndLogtoFile:(BOOL)isAll;
{
    [[HYLog shareInstance] enableLog];

    
    GSBaseResult* reslut = [GSObjMgr shareInstance].mgr.reslut;
    
    NSArray* stkArray = [GSObjMgr shareInstance].mgr.realStkRangeArray;
    
    for(long i = 0; i<[stkArray count]; i++){
        NSString* stk = [stkArray objectAtIndex:i];
        

        NSMutableArray* paramArray = [reslut paramArrayWithSymbol:stk];
        NSArray* arrayUsed = [self reOrderParamArray:paramArray];
        
        if([arrayUsed count] == 1){
            GSBaseParam* ele = [arrayUsed objectAtIndex:0];
            if(ele.totalCount == 0){
                continue;
            }
        }
        
        SMLog(@"\n");

        
//        SMLog(@"%@---summary report (%d-%d)---",stk, [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate );
//        for (long i=0; i<[arrayUsed count]; i++) {
//            GSBaseParam* ele = [arrayUsed objectAtIndex:i];
//            SMLog(@"No.(%d)- Conditon:  destDVVALUE(%.2f), duration(%d)  Result:totalS2BDVVal(%.2f), AvgVal(%.2f),totalCount(%d), sucPercent(%.2f) ",i,  ele.destDVValue,  ele.durationAfterBuy, ele.totalS2BDVValue, ele.avgS2BDVValue ,ele.totalCount, [ele getSucPecent] );
//        }
        
        if(isAll){
            SMLog(@"%@---detail report(%d-%d)---",stk, [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate);
            for (long i=0; i<[arrayUsed count]; i++) {
                GSBaseParam* ele = [arrayUsed objectAtIndex:i];
                SMLog(@"No.(%d)- Conditon:  destDVVALUE(%.2f), duration(%d)  Result:totalS2BDVVal(%.2f), AvgVal(%.2f),totalCount(%d), sucPercent(%.2f) ",i,  ele.destDVValue,  ele.durationAfterBuy, ele.totalS2BDVValue, ele.avgS2BDVValue ,ele.totalCount, [ele getSucPecent] );
                [self logAllResultWithParam:ele];
            }
        }

    }
    
    
    [[HYLog shareInstance] disableLog];
    
    SMLog(@"<--end of analysisAndLogtoFile");
}




-(void)queryAndLogtoDB;
{
    GSAssert(NO);
}



-(void)logOutResult
{
    //logOut which loss item
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    
    
    GSBaseAnalysisMgr* analyMan = [GSObjMgr shareInstance].mgr;
    
//    //calulate percent firstly
//    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
//    for(long i=0; i<[analyMan.resultArray count]; i++){
//        tmpArray = [analyMan.resultArray objectAtIndex:i];
//        
//        percent = [tmpArray count]*100.f/analyMan.totalCount;
//        
//    }
//    SMLog(@"\nSTK:%@ %d-%d totalCount(%d): win(%.2f),loss(%.2f) --totalS2BDVValue(%2f) ",analyMan.stkID,[GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate,analyMan.totalCount,winPercent,lossPercent,analyMan.totalS2BDVValue);
//    
//    
////        return;
//    
//    for(long i=0; i<[analyMan.resultArray count]; i++){
//        tmpArray = [analyMan.resultArray objectAtIndex:i];
//        
//        percent = [tmpArray count]*100.f/analyMan.totalCount;
//        
//        for (KDataModel* kData in tmpArray) {
//            [self logResWithDV:kData];
//        }
//    }
    
    
}



-(void)logResWithDV:(KDataModel*)kDataIn
{
    DVDebugData* kData = kDataIn.dvDbg;
    SMLog(@"%6ld TP1-C:%.2f, T0-O:%.2f,H:%.2f,C:%.2f,L:%.2f;  TS2B:%.2f;  T1-O:%.2f,H:%.2f,C:%.2f,L:%.2f;  T2(O:%.2f,H:%.2f,C:%.2f,L:%.2f)",kDataIn.time,
          kData.dvTP1.dvClose,
          kData.dvT0.dvOpen,kData.dvT0.dvHigh,kData.dvT0.dvClose,kData.dvT0.dvLow,
          kDataIn.tradeDbg.dvSelltoBuy,
          kData.dvT1.dvOpen,kData.dvT1.dvHigh,kData.dvT1.dvClose,kData.dvT1.dvLow,
          kData.dvT2.dvOpen,kData.dvT2.dvHigh,kData.dvT2.dvClose,kData.dvT2.dvLow);
    
}




#pragma mark - new
-(NSArray*)reOrderParamArray:(NSMutableArray*)array
{
    NSArray *resultArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GSBaseParam* par1 = obj1;
        GSBaseParam* par2 = obj2;

        NSNumber *number1 = [NSNumber numberWithFloat: par1.avgS2BDVValue];
        NSNumber *number2 = [NSNumber numberWithFloat: par2.avgS2BDVValue];

        
        NSComparisonResult result = [number1 compare:number2];
        
//        return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
    }];
    
    
    return resultArray;
}



-(void)logAllResultWithParam:(GSBaseParam*)param;
{
    [self logWithParam:param isForSel:NO];
}

-(void)logWithParam:(GSBaseParam*)param isForSel:(BOOL)isForSel;
{
    NSArray* resultArray = param.resultArray;
    long totalCount = param.totalCount;
    
    if(!isForSel){
        resultArray = param.resultArray;
        totalCount = param.totalCount;
    }
    
    //calulate percent firstly
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
    for(long i=0; i<[resultArray count]; i++){
        tmpArray = [resultArray objectAtIndex:i];
        if([tmpArray count] == 0){
            continue;
        }
        percent = [tmpArray count]*100.f/totalCount;
     
        SMLog(@"index(%ld), percent(%.2f)  count(%d) ", i, percent,[tmpArray count]);

        for (KDataModel* kData in tmpArray) {
//            SMLog(@"%@ TBuyData:%ld, TSellData:%ld, dvSelltoBuy:%.2f, MA5:%.3f, MA10:%.3f",kData.stkID, kData.tradeDbg.TBuyData.time,kData.tradeDbg.TSellData.time,kData.tradeDbg.dvSelltoBuy,kData.tradeDbg.MA5weekT0toTP5,kData.tradeDbg.MA10weekT0toTP5);
            SMLog(@"%@ TBuyData:%ld, TSellData:%ld, dvSelltoBuy:%.2f, MA5:%.3f, MA10:%.3f, MA20:%.3f; dayMA5:%.3f, dayMA10:%.3f",kData.stkID, kData.tradeDbg.TBuyData.time,kData.tradeDbg.TSellData.time,kData.tradeDbg.dvSelltoBuy,kData.tradeDbg.MA5weekT0toTP5,kData.tradeDbg.MA10weekT0toTP5,kData.tradeDbg.MA20weekT0toTP5,
                  kData.tradeDbg.MA5dayT0toTP5,kData.tradeDbg.MA10dayT0toTP5);

        }
    }

}




@end
