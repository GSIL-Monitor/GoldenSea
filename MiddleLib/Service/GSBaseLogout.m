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
        self.paramArray = [NSMutableArray array];
    }
    
    return self;
}


-(void)SimpleLogOutResult:(BOOL)isJustLogFail
{
    [self _SimpleLogOutForAll:NO isJustLogFail:isJustLogFail];
}

-(void)_SimpleLogOutForAll:(BOOL)isForAll isJustLogFail:(BOOL)isJustLogFail
{
    if(Key_JustLogOut_All){
        if(!isForAll){
            return;
        }
    }
    
    
    NSArray* resultArray = [GSObjMgr shareInstance].mgr.resultArray;
    long totalCount = [GSObjMgr shareInstance].mgr.totalCount;
    if(isForAll){
        resultArray = [GSObjMgr shareInstance].mgr.param.selResultArray;
        totalCount = [GSObjMgr shareInstance].mgr.param.selTotalCount;
    }
    
//    GSBaseAnalysisMgr* analyMan = [GSObjMgr shareInstance].mgr;
    
    //calulate percent firstly
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
    for(long i=0; i<[resultArray count]; i++){
        tmpArray = [resultArray objectAtIndex:i];
        percent = [tmpArray count]*100.f/totalCount;
        
        if(!isForAll){
            SMLog(@"\nSTK:%@ %d-%d totalCount(%d): win(%.2f),loss(%.2f) --totalS2BDVValue(%2f) ",[GSObjMgr shareInstance].mgr.stkID,[GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate,totalCount,winPercent,lossPercent,[GSObjMgr shareInstance].mgr.totalS2BDVValue);
        }else{ //for all
            SMLog(@"index(%ld), percent(%.2f)  count(%d) ", i, percent,[tmpArray count]);
        }
        
        
        
        //logout detail.
        if(isForAll){
            for (KDataModel* kData in tmpArray) {
                SMLog(@"%@ TBuyData:%ld, TSellData:%ld, dvSelltoBuy:%.2f",kData.stkID, kData.tradeDbg.TBuyData.time,kData.tradeDbg.TSellData.time, kData.tradeDbg.dvSelltoBuy);
            }
        }else{
            for (KDataModel* kData in tmpArray) {
//                SMLog(@"%6ld  LowIndex:%ld, HighIndex:%ld,  TS2B:%.2f; TBuy(%6ld)-O:%.2f,H:%.2f,C:%.2f,L:%.2f;    TSell(%6ld)-O:%.2f,H:%.2f,C:%.2f,L:%.2f; ",kData.time,kData.lowValDayIndex,kData.highValDayIndex,kData.dvSelltoBuy,
//                      kData.TBuyData.time,kData.TBuyData.dvDebugData.dvT0.dvOpen,kData.TBuyData.dvDebugData.dvT0.dvHigh,kData.TBuyData.dvDebugData.dvT0.dvClose,kData.TBuyData.dvDebugData.dvT0.dvLow,
//                      kData.TSellData.time, kData.TSellData.dvDebugData.dvT0.dvOpen,kData.TSellData.dvDebugData.dvT0.dvHigh,kData.TSellData.dvDebugData.dvT0.dvClose,kData.TSellData.dvDebugData.dvT0.dvLow                      );
            }
        }
        
    }
    
    
    

    
    
}


//base analysis: deal to one stk.
-(void)analysisAndLogtoFile;
{
    [self reOrderParamArray];
    
    [[HYLog shareInstance] enableLog];
    
    //    KeyTimeObj* keyTimeObj = [[KeyTimeObj alloc]init];
    
    
    NSArray* arrayUsed = self.paramArray;
    
    SMLog(@"---summary report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate );
    for (long i=0; i<[arrayUsed count]; i++) {
        GSBaseParam* ele = [arrayUsed objectAtIndex:i];
        SMLog(@"No.(%d)- Conditon:  DESTDVVALUE(%.2f), duration(%d)  Result:allTotalS2BDVValue(%.2f), totalAvgVal(%.2f),totalCount(%d), SelCount(%d), selAvg(%.2f) ",i,  ele.destDVValue,  ele.durationAfterBuy, ele.allTotalS2BDVValue, ele.allAvgS2BDVValue ,ele.allTotalCount,ele.selTotalCount,ele.selAvgS2BDVValue );
    }
    
    SMLog(@"\n");
    SMLog(@"---detail report(%d-%d)---", [GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate);
    for (long i=0; i<[arrayUsed count]; i++) {
        GSBaseParam* ele = [arrayUsed objectAtIndex:i];
        SMLog(@"No.(%d)- Conditon:  DESTDVVALUE(%.2f), duration(%d)  Result:avgVal(%.2f),totalCount(%d), SelCount(%d), selAvg(%.2f) ",i,  ele.destDVValue,  ele.durationAfterBuy, ele.allAvgS2BDVValue ,ele.allTotalCount,ele.selTotalCount,ele.selAvgS2BDVValue );
        //        [self logSelResultWithParam:ele];
        [self logAllResultWithParam:ele];
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
    
    //calulate percent firstly
    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
    for(long i=0; i<[analyMan.resultArray count]; i++){
        tmpArray = [analyMan.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/analyMan.totalCount;
        
    }
    SMLog(@"\nSTK:%@ %d-%d totalCount(%d): win(%.2f),loss(%.2f) --totalS2BDVValue(%2f) ",analyMan.stkID,[GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate,analyMan.totalCount,winPercent,lossPercent,analyMan.totalS2BDVValue);
    
    
//        return;
    
    for(long i=0; i<[analyMan.resultArray count]; i++){
        tmpArray = [analyMan.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/analyMan.totalCount;
        
        for (KDataModel* kData in tmpArray) {
            [self logResWithDV:kData];
        }
    }
    
    
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
-(void)reOrderParamArray
{
    NSMutableArray* array = self.paramArray;
    
    
    NSArray *resultArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GSBaseParam* par1 = obj1;
        GSBaseParam* par2 = obj2;
//        NSNumber *number1 = [NSNumber numberWithFloat: par1.selTotalS2BDVValue];
//        NSNumber *number2 = [NSNumber numberWithFloat: par2.selTotalS2BDVValue];

        NSNumber *number1 = [NSNumber numberWithFloat: par1.selAvgS2BDVValue];
        NSNumber *number2 = [NSNumber numberWithFloat: par2.selAvgS2BDVValue];

        
        NSComparisonResult result = [number1 compare:number2];
        
//        return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
    }];
    
    
    self.paramArray = (NSMutableArray*)resultArray;
}

-(void)logSelResultWithParam:(GSBaseParam*)param;
{
    [self logWithParam:param isForSel:YES];
}

-(void)logAllResultWithParam:(GSBaseParam*)param;
{
    [self logWithParam:param isForSel:NO];
}

-(void)logWithParam:(GSBaseParam*)param isForSel:(BOOL)isForSel;
{
    NSArray* resultArray = param.selResultArray;
    long totalCount = param.selTotalCount;
    
    if(!isForSel){
        resultArray = param.allResultArray;
        totalCount = param.allTotalCount;
    }
    
    //calulate percent firstly
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
    for(long i=0; i<[resultArray count]; i++){
        tmpArray = [resultArray objectAtIndex:i];
        percent = [tmpArray count]*100.f/totalCount;
        
     
        SMLog(@"index(%ld), percent(%.2f)  count(%d) ", i, percent,[tmpArray count]);

        for (KDataModel* kData in tmpArray) {
            SMLog(@"%@ TBuyData:%ld, pvHi2Op(%.3f), TSellData:%ld, dvSelltoBuy:%.2f",kData.stkID, kData.tradeDbg.TBuyData.time,kData.tradeDbg.pvHi2Op,kData.tradeDbg.TSellData.time,kData.tradeDbg.dvSelltoBuy);
        }
    }

}


#pragma mark - getter&setter
//-(NSMutableArray*)countArray{
//    if(!_countArray){
//        _countArray = [NSMutableArray array];
//        for(long i=0; i<9; i++){
//            NSNumber* count = [NSNumber numberWithInt:0];
//            [_countArray addObject:count];
//        }
//    }
//    
//    return _countArray;
//}

@end
