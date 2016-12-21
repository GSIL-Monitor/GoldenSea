//
//  GSFileManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/4/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseAnalysisMgr.h"
#import "KDataModel.h"
#import "GSBaseLogout.h"
#import "GSDataMgr.h"
#import "GSBaseAnalysisMgr+ex.h"
#import "GSCondition.h"

#import "NewStkAnalysisMgr.h"
#import "STATAnalysisMgr.h"

@interface GSBaseAnalysisMgr ()



@end


@implementation GSBaseAnalysisMgr



-(id)init
{
    if(self = [super init]){
        self.realStkRangeArray = [NSMutableArray array];
    }
    
    return self;
}

-(void)queryAllWithFile:(NSString*)docsDir;
{
    self.isWriteToQueryDB = YES;
    
    [self _queryAllWithDB:docsDir];
}

-(void)queryAllWithDB:(NSString*)docsDir;
{
    self.isWriteToQueryDB = NO;
    
    self.stkRangeArray = [[GSDataMgr shareInstance]getStkRangeFromQueryDB]; //tmp

    
    [self _queryAllWithDB:docsDir];

}

-(void)_queryAllWithDB:(NSString*)docsDir;
{
    self.queryResArray = [NSMutableArray array];
    self.querySTKArray = [NSMutableArray array];

    
    NSMutableArray* files = [[GSDataMgr shareInstance]findSourcesInDir:docsDir];
    for(NSString* file in files){
        [self resetForOne];
        self.stkID = [HelpService stkIDWithFile:file];
        
        if(![self isInRange:self.stkID]){
            continue;
        }
        
        [self readContentArrayFromDB];
        
        [self query];
    }
    
    [self queryAndLogtoDB];
    
    SMLog(@"end of queryAllInDir");
    
}

-(void)analysisQuerySTKArray:(NSString*)docsDir;
{
    if([self.querySTKArray count] == 0){
        SMLog(@"no result stk with query!!!");
        return;
    }
    
    [self _analysisSTKInDir:docsDir rangeArray:self.querySTKArray];
    
    
}

-(void)queryAndLogtoDB
{
    
}

-(void)analysisAllInDir:(NSString*)docsDir;
{
    [self _analysisSTKInDir:docsDir rangeArray:self.stkRangeArray];
}

-(void)_analysisSTKInDir:(NSString*)docsDir rangeArray:(NSArray*)rangeArray;
{
    //    SMLog(@"start analysisAllInDir with Param(destDVValue:%.2f)",self.param.destDVValue);
    
    NSMutableArray* files = [[GSDataMgr shareInstance]findSourcesInDir:docsDir];
    for(NSString* file in files){
        [self resetForOne];
        self.stkID = [HelpService stkIDWithFile:file];
        
        GSBaseParam* param = [self.param copy];
        self.param = param;
        
        if(![self isInRange:self.stkID rangeArray:rangeArray]){
            continue;
        }
        
        if(![self.realStkRangeArray containsObject:self.stkID]){
            [self.realStkRangeArray addObject:self.stkID];
        }
        
        //        SMLog(@"stkID: %@",self.stkID);
        [self readContentArrayFromDB];
        
        [self analysis];
        
        
        [self.reslut setSTK:self.stkID pararm:self.param];
    }
    
    
}


-(void)readContentArrayFromDB
{
    if([self isKindOfClass:[NewStkAnalysisMgr class]]){
        self.NSTKdayCxtArray = [[GSDataMgr shareInstance]getNSTKDayDataFromDB:self.stkID];
    }else if([self isKindOfClass:[STATAnalysisMgr class]]){
        switch (self.period) {
            case Period_day:
                self.dayCxtArray = [[GSDataMgr shareInstance]getDayDataFromDB:self.stkID];
                break;
                
            case Period_week:
                self.weekCxtArray = [[GSDataMgr shareInstance]getWeekDataFromDB:self.stkID];
                break;
                
            case Period_month:
                self.monthCxtArray = [[GSDataMgr shareInstance]getMonthDataFromDB:self.stkID];
                break;
                
            default:
                break;
        }
    }
    else{
        self.dayCxtArray = [[GSDataMgr shareInstance]getDayDataFromDB:self.stkID];
        self.weekCxtArray = [[GSDataMgr shareInstance]getWeekDataFromDB:self.stkID];
        self.monthCxtArray = [[GSDataMgr shareInstance]getMonthDataFromDB:self.stkID];
    }
}


-(void)query
{
    GSAssert(NO);
}



-(void)analysis
{
    NSArray* cxtArray = [self getCxtArray:self.period];
    
    if(! [self isValidDataPassedIn] || [cxtArray count]<20){
        return;
    }
    
    NSDictionary* passDict;
    for(long i=6; i<[cxtArray count]-3; i++ ){
        KDataModel* kTP6Data  = [cxtArray objectAtIndex:(i-6)];
        KDataModel* kTP5Data  = [cxtArray objectAtIndex:(i-5)];
        KDataModel* kTP4Data  = [cxtArray objectAtIndex:(i-4)];
        KDataModel* kTP3Data  = [cxtArray objectAtIndex:(i-3)];
        KDataModel* kTP2Data  = [cxtArray objectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [cxtArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [cxtArray objectAtIndex:i];
        KDataModel* kT1Data = [cxtArray objectAtIndex:i+1];
        KDataModel* kT2Data = [cxtArray objectAtIndex:i+2];
        
        
        
        kT0Data.tradeDbg.T1Data = kT1Data;
        kT0Data.tradeDbg.TP1Data = kTP1Data;
        
        kT0Data.dvDbg.dvTP2 = [UtilData getDVValue:cxtArray baseIndex:i-3 destIndex:i-2];
        kT0Data.dvDbg.dvTP1 = [UtilData getDVValue:cxtArray baseIndex:i-2 destIndex:i-1];
        kT0Data.dvDbg.dvT0 = [UtilData getDVValue:cxtArray baseIndex:i-1 destIndex:i];
        kT0Data.dvDbg.dvT1 = [UtilData getDVValue:cxtArray baseIndex:i destIndex:i+1];
        kT0Data.dvDbg.dvT2 = [UtilData getDVValue:cxtArray baseIndex:i+1 destIndex:i+2];
        
        kT0Data.dvDbg.dvAvgTP1toTP5 = [UtilData getAvgDVValue:5 array:cxtArray index:i-1];
        
        
        passDict = @{@"kTP6Data":kTP6Data, @"kTP5Data":kTP5Data, @"kTP4Data":kTP4Data,@"kTP3Data":kTP3Data, @"kTP2Data":kTP2Data, @"kTP1Data":kTP1Data,@"kT0Data":kT0Data, @"kT1Data":kT1Data};
        
        
        //dv condintoon
        if(![self isMeetDVConditon:self.tp2dayCond DVValue:kT0Data.dvDbg.dvTP2]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.tp1dayCond DVValue:kT0Data.dvDbg.dvTP1]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.t0dayCond DVValue:kT0Data.dvDbg.dvT0]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.t1dayCond DVValue:kT0Data.dvDbg.dvT1]){
            continue;
        }
        
        
        
        
        //shape condition
        if(![[GSCondition shareInstance] isMeetShapeCond:passDict]){
            continue;
        }
        
        //t0 condition
        if(![self isMeetT0Condition:passDict]){
            continue;
        }
        
        //        if(![self isMeetAddtionCond:passDict]){
        //            continue;
        //        }
        
//        [self dispatchResult2Array:kT0Data buyIndex:i sellIndex:i+1];
        
    }
    
    
    
    [[GSObjMgr shareInstance].log  logOutResult];

    
}


-(BOOL)isMeetAddtionCond:(NSDictionary*)passDict
{
    if(!passDict)
        return YES;
    
    KDataModel* kTP2Data  = [passDict objectForKey:@"kTP2Data"];
    KDataModel* kTP1Data  = [passDict objectForKey:@"kTP1Data"];
    KDataModel* kT0Data = [passDict objectForKey:@"kT0Data"];
    KDataModel* kT1Data = [passDict objectForKey:@"kT1Data"];
    
    
    if((kTP2Data.open > kTP2Data.close)
        &&(kTP1Data.open > kTP1Data.close)
       &&(kT0Data.open < kT0Data.close)){
        if(kTP2Data.dvDbg.dvT0.dvClose > -2.f
           && kTP1Data.dvDbg.dvT0.dvClose > -2.f
           && fabs(kT0Data.open - kT0Data.close) < 0.15f
           && kT0Data.dvDbg.dvT0.dvClose < 1.f)
        return YES;
    }
    
    
    return NO;
}




#pragma mark - condition
-(BOOL)isMeetT0Condition:(NSDictionary*)passDict
{
    if(!passDict)
        return YES;

    KDataModel* kT0Data = [passDict objectForKey:@"kT0Data"];
    
    switch ([GSCondition shareInstance].t0Cond) {
        case T0Condition_Up:
        {
            if(kT0Data.open < kT0Data.close){
                return YES;
            }
        }
            break;
            
        case T0Condition_Down:
        {
            if(kT0Data.open > kT0Data.close){
                return YES;
            }
        }
            break;
            
        default:
            return YES;
            break;
    }
    
    
    return NO;
}


-(BOOL)isMeetDVConditon:(OneDayCondition*)cond DVValue:(DVValue*)dv;
{
    if(!cond){
        return YES;
    }
    
    
    if(!(dv.dvOpen > cond.open_min
         && dv.dvOpen < cond.open_max)){
        return NO;
    }
    
    if(!(dv.dvHigh > cond.high_min
         && dv.dvHigh < cond.high_max)){
        return NO;
    }
    
    if(!(dv.dvLow > cond.low_min
         && dv.dvLow < cond.low_max)){
        return NO;
    }
    
    if(!(dv.dvClose > cond.close_min
         && dv.dvClose < cond.close_max)){
        return NO;
    }
    
    return YES;
}




#pragma mark - common
//start:(long)startIndex stop:(long)stopIndex
-(CGFloat)getSellValue:(CGFloat)buyValue kT0data:(KDataModel*)kT0Data cxtArray:(NSArray*)cxtArray start:(long)startIndex stop:(long)stopIndex;
{
    CGFloat sellValue;
    
    GSBaseAnalysisMgr* man = self;
    CGFloat destValue = (1+man.param.destDVValue/100.f)*buyValue;
    long durationAfterBuy = self.param.durationAfterBuy;
    long sIndex = [HelpService indexOfValueGreatThan:destValue Array:cxtArray start:startIndex stop:stopIndex kT0data:kT0Data];
    if(sIndex != -1){ //find
        sellValue = (1+man.param.destDVValue/100.f)*buyValue;
    }else{
        long sellIndex ;
        if(stopIndex < [cxtArray count]){
            sellIndex = stopIndex;
        }else{
            sellIndex = ([cxtArray count] - 1) > (startIndex+1) ? ([cxtArray count] - 1):stopIndex;
        }
        
        kT0Data.tradeDbg.TSellData = [cxtArray safeObjectAtIndex:sellIndex];
        if(kT0Data.tradeDbg.TSellData){ //if had data in that day.
            sellValue = kT0Data.tradeDbg.TSellData.close;
            kT0Data.tradeDbg.TSellDataIndex = sellIndex;
        }else{
            sellValue = buyValue;
        }
    }
    
    
    return sellValue;
}


-(NSArray*)getCxtArray:(long)period;
{
    switch (period) {
        case Period_day:
            return self.dayCxtArray;
            break;
            
        case Period_week:
            return self.weekCxtArray;
            break;
            
        case Period_month:
            return self.monthCxtArray;
            break;
            
        default:
            return self.dayCxtArray;
            break;
    }
}



@end
