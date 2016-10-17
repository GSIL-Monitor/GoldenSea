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

@interface GSBaseAnalysisMgr ()



@end


@implementation GSBaseAnalysisMgr



-(id)init
{
    if(self = [super init]){
        
    }
    
    return self;
}

-(void)queryAllAndSaveToDBWithFile:(NSString*)docsDir;
{
    self.isWriteToQueryDB = YES;
    
    [self _queryAllWithDB:docsDir];
}

-(void)queryAllWithDB:(NSString*)docsDir;
{
    self.isWriteToQueryDB = NO;
    
    self.stkRangeArray = [[GSDataMgr shareInstance]getStkRangeFromQueryDB];

    
    [self _queryAllWithDB:docsDir];

}

-(void)_queryAllWithDB:(NSString*)docsDir;
{
    [GSDataMgr shareInstance].startDate = 20160601;
    
    self.queryResArray = [NSMutableArray array];

    
    NSMutableArray* files = [[GSDataMgr shareInstance]findSourcesInDir:docsDir];
    for(NSString* file in files){
        [self resetForOne];
        self.stkID = [HelpService stkIDWithFile:file];
        
        if(![self isInRange:self.stkID]){
            continue;
        }
        
        self.contentArray = [[GSDataMgr shareInstance] getDayDataFromDB:self.stkID];
        
        [self query];
    }
    
    [self queryAndLogtoDB];
    
    SMLog(@"end of queryAllInDir");
    
}



-(void)analysisAllInDir:(NSString*)docsDir;
{
    SMLog(@"start analysisAllInDir with Param(destDVValue:%.2f)",self.param.destDVValue);
    
    NSMutableArray* files = [[GSDataMgr shareInstance]findSourcesInDir:docsDir];
    for(NSString* file in files){
        [self resetForOne];
        self.stkID = [HelpService stkIDWithFile:file];
        
        if(![self isInRange:self.stkID]){
            continue;
        }
        
//        SMLog(@"stkID: %@",self.stkID);
        self.contentArray = [[GSDataMgr shareInstance]getDayDataFromDB:self.stkID];

        [self analysis];
        
        
        [self.reslut setSTK:self.stkID pararm:self.param];
    }
    
//    [self.param calcSelAvg]; 
//    
//    [[GSObjMgr shareInstance].log.paramArray addObject:self.param];
    
}



-(void)query
{
    GSAssert(NO);
}



-(void)analysis
{
    if(! [self isValidDataPassedIn] || [self.contentArray count]<20){
        return;
    }
    
    NSDictionary* passDict;
    for(long i=6; i<[self.contentArray count]-3; i++ ){
        KDataModel* kTP6Data  = [self.contentArray objectAtIndex:(i-6)];
        KDataModel* kTP5Data  = [self.contentArray objectAtIndex:(i-5)];
        KDataModel* kTP4Data  = [self.contentArray objectAtIndex:(i-4)];
        KDataModel* kTP3Data  = [self.contentArray objectAtIndex:(i-3)];
        KDataModel* kTP2Data  = [self.contentArray objectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [self.contentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i];
        KDataModel* kT1Data = [self.contentArray objectAtIndex:i+1];
        KDataModel* kT2Data = [self.contentArray objectAtIndex:i+2];
        
        
        
        kT0Data.tradeDbg.T1Data = kT1Data;
        kT0Data.tradeDbg.TP1Data = kTP1Data;
        
        kT0Data.dvDbg.dvTP2 = [UtilData getDVValue:self.contentArray baseIndex:i-3 destIndex:i-2];
        kT0Data.dvDbg.dvTP1 = [UtilData getDVValue:self.contentArray baseIndex:i-2 destIndex:i-1];
        kT0Data.dvDbg.dvT0 = [UtilData getDVValue:self.contentArray baseIndex:i-1 destIndex:i];
        kT0Data.dvDbg.dvT1 = [UtilData getDVValue:self.contentArray baseIndex:i destIndex:i+1];
        kT0Data.dvDbg.dvT2 = [UtilData getDVValue:self.contentArray baseIndex:i+1 destIndex:i+2];
        
        kT0Data.dvDbg.dvAvgTP1toTP5 = [UtilData getAvgDVValue:5 array:self.contentArray index:i-1];
        
        
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
        
        [self dispatchResult2Array:kT0Data buyIndex:i sellIndex:i+1];
        
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
-(CGFloat)getSellValue:(CGFloat)buyValue kT0data:(KDataModel*)kT0Data start:(long)startIndex stop:(long)stopIndex;
{
    CGFloat sellValue;
    
    GSBaseAnalysisMgr* man = self;
    CGFloat destValue = (1+man.param.destDVValue/100.f)*buyValue;
    long durationAfterBuy = self.param.durationAfterBuy;
    long sIndex = [HelpService indexOfValueGreatThan:destValue Array:man.contentArray start:startIndex stop:stopIndex kT0data:kT0Data];
    if(sIndex != -1){ //find
        sellValue = (1+man.param.destDVValue/100.f)*buyValue;
    }else{
        kT0Data.tradeDbg.TSellData = [man.contentArray safeObjectAtIndex:stopIndex];
        if(kT0Data.tradeDbg.TSellData){ //if had data in that day.
            sellValue = kT0Data.tradeDbg.TSellData.close;
        }else{
            sellValue = buyValue;
        }
    }
    
    
    return sellValue;
}



@end
