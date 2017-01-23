//
//  LimitAnalysisMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "LimitAnalysisMgr.h"
#import "RaisingLimitParam.h"



@interface LimitAnalysisMgr ()

@property (nonatomic, strong) RaisingLimitParam* param;


@end

@implementation LimitAnalysisMgr


-(BOOL)isMapPreCondition:(NSArray*)cxtArray index:(long)i
{
    BOOL isMap = YES;
    
    KDataModel* kTP1Data  = [cxtArray objectAtIndex:(i-1)];
    if(self.param.daysAfterLastLimit == 0)
    {
        //filter raise much in shorttime
        if(![self.param isMapRasingLimitAvgConditon:kTP1Data]){
            isMap = NO;
        }
    }
    else
    {
        //filter raise much in shorttime
        if(![self.param isMapRasingLimitAvgConditonMa30:kTP1Data]){
            isMap = NO;
        }
        
        if(![self.param isNoLimitInLastDaysBeforeIndex:i contentArray:cxtArray]){
            isMap = NO;
        }
    }

    return isMap;
}



//used for deep-down
-(void)queryTodayisDown
{
    NSArray* cxtArray = [self getCxtArray:self.period];
    
    //skip new stk.
    if([cxtArray count]<kNSTK_DayCount){
        return;
    }
    
    long todayIndex = [cxtArray count]-1;
    KDataModel* kTodayData = [cxtArray objectAtIndex:todayIndex];
    for(long i=[cxtArray count]-2; i>[cxtArray count]-6; i-- ){
        KDataModel* kTP1Data  = [cxtArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [cxtArray objectAtIndex:i];
        kT0Data.isLimitUp =  [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.close];
        
        
        if(kT0Data.isLimitUp){
            CGFloat dv = kTodayData.close/kT0Data.close;
            if(dv < 0.96){
                SMLog(@"%@: %ld dv(%.3f)",self.stkID,kT0Data.time,dv);
            }
            break;
        }
    }
}


-(void)query
{
    [self queryTodayisDown];
    return;
    
    NSArray* cxtArray = [self getCxtArray:self.period];

    //skip new stk.
    if([cxtArray count]<kNSTK_DayCount){
        return;
    }
    
    long lastIndex = [cxtArray count]-1;
    for(long i=[cxtArray count]-3; i<[cxtArray count]-1; i++ ){
        KDataModel* kTP1Data  = [cxtArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [cxtArray objectAtIndex:i];
        kT0Data.isLimitUp =  [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.close];
        
        
        if(kT0Data.isLimitUp){
            
            kTP1Data.ma5 = [UtilData getMAValue:5 array:cxtArray t0Index:i-1];
            kTP1Data.ma10 = [UtilData getMAValue:10 array:cxtArray t0Index:i-1];
            kTP1Data.ma30 = [UtilData getMAValue:30 array:cxtArray t0Index:i-1];

            
            if(![self isMapPreCondition:cxtArray index:i])
            {
                continue;
            }
            
            //filter raise much in shorttime
            if(kT0Data.time >= 20161230){ // && kT0Data.time <= 20160816
                KDataModel* kTLastData = [cxtArray objectAtIndex:lastIndex];
                CGFloat pvLast2kTP1DataMA5 = kTLastData.close/kTP1Data.ma5;
 
                //save to array
                QueryResModel* model = [[QueryResModel alloc]init];
                model.stkID = self.stkID;
                model.time = kT0Data.time;
                model.pvLast2kTP1DataMA5 = pvLast2kTP1DataMA5;
                model.buyVal = kTP1Data.ma5*self.param.buyPercent;
                [self.queryResArray addObject:model];
            }
        }
    }
    
}


-(void)queryAndLogtoDB;
{
    //reorder
    NSMutableArray* array = self.queryResArray;
    NSArray *resultArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        QueryResModel* par1 = obj1;
        QueryResModel* par2 = obj2;
        NSNumber *number1 = [NSNumber numberWithFloat: par1.pvLast2kTP1DataMA5];
        NSNumber *number2 = [NSNumber numberWithFloat: par2.pvLast2kTP1DataMA5];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending; // 升序
        //        return result == NSOrderedAscending;  // 降序
    }];
    self.queryResArray = (NSMutableArray*)resultArray;
    
    
    [[HYLog shareInstance] enableLog];

    for(long i=0; i<[self.queryResArray count]; i++){
        QueryResModel* model = [self.queryResArray objectAtIndex:i];
        SMLog(@"%@ time:%ld, buyVal(%.2f), pvLast(%.2f)",[model.stkID substringFromIndex:2],model.time, model.buyVal, model.pvLast2kTP1DataMA5);
        
//        //write to queryDB if need.
//        if(self.isWriteToQueryDB){
//            [[QueryDBManager defaultManager].qREsDBService addRecord:model];
//        }
    }
    
    [[HYLog shareInstance] disableLog];

}




-(void)analysis
{
    NSArray* cxtArray = [self getCxtArray:self.period];
    
    if(! [self isValidDataPassedIn] || [cxtArray count]< kNSTK_DayCount ) // || [cxtArray count]<20)
    {
        return;
    }
    
    long statDays = 5;
    long middleIndex = 7;
    for(long i=5; i<[cxtArray count]-statDays; i++ ){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        
        KDataModel* kTP5Data  = [cxtArray safeObjectAtIndex:(i-5)];
        KDataModel* kTP1Data  = [cxtArray safeObjectAtIndex:(i-1)];
        KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
        KDataModel* kT1Data = [cxtArray safeObjectAtIndex:i+1];
        //        KDataModel* kT2Data = [cxtArray safeObjectAtIndex:i+2];
        //        KDataModel* kT3Data = [cxtArray safeObjectAtIndex:i+3];
        //        KDataModel* kT4Data = [cxtArray safeObjectAtIndex:i+4];
                KDataModel* kT5Data = [cxtArray safeObjectAtIndex:i+5];
        //        KDataModel* kT6Data = [cxtArray safeObjectAtIndex:i+6];
        //        KDataModel* kT7Data = [cxtArray safeObjectAtIndex:i+7];
        //        KDataModel* kT8Data = [cxtArray safeObjectAtIndex:i+8];
        //        KDataModel* kT9Data = [cxtArray safeObjectAtIndex:i+9];
        
        
        CGFloat upDv = kT0Data.close/kTP5Data.close;
        CGFloat downDv = kT5Data.close/kT0Data.close;
        if(upDv > 1.25 && downDv < 0.78){
            SMLog(@"%@: %ld upDv(%.3f), downDv(%.3f)",self.stkID,kT0Data.time,upDv,downDv);
        }
    }
    
    
    [[GSObjMgr shareInstance].log SimpleLogOutResult:NO];
    
}

//
//-(void)analysis
//{
////    [self queryZhang];
////    return;
//    
//    
//    NSArray* cxtArray = [self getCxtArray:self.period];
//
//    if(! [self isValidDataPassedIn] || [cxtArray count]< kNSTK_DayCount ) // || [cxtArray count]<20)
//    {
//        return;
//    }
//    
//    
//    long statDays = 2;
//    long middleIndex = 7;
//    for(long i=1; i<[cxtArray count]-statDays; i++ ){
//        CGFloat buyValue = 0.f;
//        CGFloat sellValue = 0.f;
//        
//        KDataModel* kTP1Data  = [cxtArray safeObjectAtIndex:(i-1)];
//        KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
//        KDataModel* kT1Data = [cxtArray safeObjectAtIndex:i+1];
//        //        KDataModel* kT2Data = [cxtArray safeObjectAtIndex:i+2];
//        //        KDataModel* kT3Data = [cxtArray safeObjectAtIndex:i+3];
//        //        KDataModel* kT4Data = [cxtArray safeObjectAtIndex:i+4];
//        //        KDataModel* kT5Data = [cxtArray safeObjectAtIndex:i+5];
//        //        KDataModel* kT6Data = [cxtArray safeObjectAtIndex:i+6];
//        //        KDataModel* kT7Data = [cxtArray safeObjectAtIndex:i+7];
//        //        KDataModel* kT8Data = [cxtArray safeObjectAtIndex:i+8];
//        //        KDataModel* kT9Data = [cxtArray safeObjectAtIndex:i+9];
//        
//        
//        kT0Data.tradeDbg.lowValDayIndex = 1;
//        kT0Data.tradeDbg.highValDayIndex = 5;
//        
////        if(kT0Data.time == 20161021){
////            SMLog(@"");
////        }
//        
//        if(kT0Data.isLimitUp){
////            if((kT0Data.time > 20150813 && kT0Data.time < 20150819)
////               ||(kT0Data.time > 20150615 && kT0Data.time < 20150702)
////               ||(kT0Data.time > 20151230 && kT0Data.time < 20160115)){
////                continue;
////            }
//            
//            
//            if(![self isMapPreCondition:cxtArray index:i])
//            {
//                continue;
//            }
//            
//            kT0Data.stkID = self.stkID;
//
//            
//            //dbg
////            if([self.stkID isEqual:@"SZ002005"]
//////               && kT0Data.time == 20160519
////               ){
////                SMLog(@"");
////            }
//            
////            if([self.stkID isEqual:@"SZ000592"] && kT0Data.time == 20160728){
////                SMLog(@"");
////            }
//            
//            
//            if(![self isShiZi:kT1Data kT0Data:kT0Data]){
//                continue;
//            }
//            
//
//            buyValue = kT1Data.close ;
//            kT0Data.tradeDbg.TBuyData = kT1Data;
//            
//            long start = i+2;
//            long stop = start+self.param.durationAfterBuy;
//            sellValue = [self getSellValue:buyValue  kT0data:kT0Data  cxtArray:cxtArray  start:start stop:stop];
//            
//            if(kT0Data.tradeDbg.TSellData)
//                [self dispatchResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
//            
//        }
//        
//    }
//    
//    
//    [[GSObjMgr shareInstance].log SimpleLogOutResult:NO];
//    
//}


-(BOOL)isShiZi:(KDataModel*)kT1Data kT0Data:(KDataModel*)kT0Data
{
    BOOL isShiZi = NO;
    
    CGFloat oc = fabs(kT1Data.close-kT1Data.open);
    CGFloat ocdv = oc/kT0Data.close;
    
    if(1
       && ocdv < 0.015f
       && kT1Data.high/kT0Data.close < 1.05f
       && kT1Data.low/kT0Data.close > 0.96f
//       && kT1Data.close>kT0Data.close
       ){
        isShiZi = YES;
    }
    
    //似乎效果不错
//    if( kT1Data.close/kT1Data.open < 1.05f
//       && kT1Data.close/kT1Data.open > 0.9f
//       ){
//        isShiZi = YES;
//    }
    
    return isShiZi;
}



//long bIndex = [HelpService indexOfValueSmallThan:buyValue Array:cxtArray start:i+self.param.buyStartIndex stop:i+self.param.buyEndIndex kT0data:kT0Data];
//if(bIndex == -1){ //not find
//    continue;
//}
//
//kT0Data.tradeDbg.TBuyData = [cxtArray objectAtIndex:i+self.param.buyStartIndex+bIndex];
//
//long start = i+self.param.buyStartIndex+bIndex+1;
//long stop = start+self.param.durationAfterBuy;


#pragma setter //tbd.
//-(void)setParam:(RaisingLimitParam *)oldParam
//{
//    RaisingLimitParam* param = [[RaisingLimitParam alloc]init];
//    param.durationAfterBuy = oldParam.durationAfterBuy;
//    param.buyPercent = oldParam.buyPercent;
//    param.daysAfterLastLimit = oldParam.daysAfterLastLimit;
//    param.destDVValue = oldParam.destDVValue;
//    param.cutDVValue = oldParam.cutDVValue;
//
//    param.buyStartIndex = oldParam.buyStartIndex;
//    param.buyEndIndex = oldParam.buyEndIndex;
//
//    _param = param;
//}


@end
