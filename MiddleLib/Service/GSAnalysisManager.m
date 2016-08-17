//
//  GSFileManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/4/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSAnalysisManager.h"
#import "KDataModel.h"
#import "GSLogout.h"
#import "GSDataInit.h"
#import "GSAnalysisManager+ex.h"
#import "GSCondition.h"

@interface GSAnalysisManager ()

@property (nonatomic,assign) long startLogCount;

@end


@implementation GSAnalysisManager

SINGLETON_GENERATOR(GSAnalysisManager, shareManager);


-(id)init
{
    if(self = [super init]){
        _destDVValue = 2.5f;
        _stopDVValue = -3.5f;
        _startLogCount = 0;
    }
    
    return self;
}


-(void)_analysisFile:(NSString*)stkUUID inDir:(NSString*)docsDir
{
    //reset content when every time read file.
    [self resetForOne];
    
    self.stkID = stkUUID;
    
    
//    self.contentArray = [[GSDataInit shareManager] buildDataWithStkUUID:stkUUID inDir:docsDir];
    self.contentArray = [[GSDataInit shareManager]getDataFromDB:self.stkID];
    
    //        [self analysis];
//    [self analysisForRaisingLimit];
    [self queryRaisingLimit];
}

-(void)analysisAllInDir:(NSString*)docsDir;
{
    [self resetForAll];
    
    long dbgNum = 0;
    
    NSMutableArray* files = [[GSDataInit shareManager]findSourcesInDir:docsDir];
    for(NSString* file in files){
        [self resetForOne];
        self.stkID = [HelpService stkIDWithFile:file];
        
//        self.contentArray = [[GSDataInit shareManager] getStkContentArray:file];
        self.contentArray = [[GSDataInit shareManager]getDataFromDB:self.stkID];

        
//        [self analysis];
        [self analysisForRaisingLimit];
//        [self queryRaisingLimit];
        
//        //debug
//        if(dbgNum++ > 20){
//            break;
//        }
    }
    
    
    [[GSLogout shareManager]logOutAllResult];
    
    SMLog(@"end of analysisAll");
}


-(void)queryRaisingLimit
{
    
    if(![self.contentArray count]){
        return;
    }
    
    NSDictionary* passDict;
    long statDays = 1;
    for(long i=0; i<[self.contentArray count]-statDays; i++ ){
        
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i];
        
        kT0Data.lowValDayIndex = 1;
        kT0Data.highValDayIndex = 5;
        
        if(kT0Data.isLimitUp){
            SMLog(@"%@ kT0Data: %ld",[self.stkID substringFromIndex:2],kT0Data.time);
            continue;
        }
        
    }
    
    
    
    if(self.totalCount > self.startLogCount){
        [[GSLogout shareManager] SimpleLogOutResult:NO];
    }
    
}



-(void)analysisForRaisingLimit
{
    if(! [self isValidDataPassedIn] || [self.contentArray count]<20){
        return;
    }
    
    NSDictionary* passDict;
    long statDays = 11;
    long middleIndex = 7;
    for(long i=6; i<[self.contentArray count]-statDays; i++ ){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        
        KDataModel* kTP1Data  = [self.contentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i];
        KDataModel* kT1Data = [self.contentArray objectAtIndex:i+1];
        KDataModel* kT2Data = [self.contentArray objectAtIndex:i+2];
        KDataModel* kT3Data = [self.contentArray objectAtIndex:i+3];
        KDataModel* kT4Data = [self.contentArray objectAtIndex:i+4];
        KDataModel* kT5Data = [self.contentArray objectAtIndex:i+5];
        KDataModel* kT6Data = [self.contentArray objectAtIndex:i+6];
        KDataModel* kT7Data = [self.contentArray objectAtIndex:i+7];
        KDataModel* kT8Data = [self.contentArray objectAtIndex:i+8];
        KDataModel* kT9Data = [self.contentArray objectAtIndex:i+9];

        
        kT0Data.lowValDayIndex = 1;
        kT0Data.highValDayIndex = 5;
        
        if(kT0Data.isLimitUp){
            kT0Data.dvT1 = [[GSDataInit shareManager] getDVValue:self.contentArray baseIndex:i destIndex:i+1];
            kT7Data.dvT0 = [[GSDataInit shareManager] getDVValue:self.contentArray baseIndex:i+6 destIndex:i+7];
            kT8Data.dvT0 = [[GSDataInit shareManager] getDVValue:self.contentArray baseIndex:i+7 destIndex:i+8];
            kT9Data.dvT0 = [[GSDataInit shareManager] getDVValue:self.contentArray baseIndex:i+8 destIndex:i+9];

            //            if(kT0Data.dvT1.dvClose < 0.f)
            {
                
                if((kT0Data.time > 20150813 && kT0Data.time < 20150819)
                   ||(kT0Data.time > 20150615 && kT0Data.time < 20150702)
                   ||(kT0Data.time > 20151230 && kT0Data.time < 20160115)){
                    continue;
                }
                
                //filter raise much in shorttime
                CGFloat dvMa5AndClose = [[GSDataInit shareManager]getDVValueWithBaseValue:kTP1Data.ma5 destValue:kTP1Data.close];
                CGFloat dvMa10AndClose = [[GSDataInit shareManager]getDVValueWithBaseValue:kTP1Data.ma10 destValue:kTP1Data.close];
                if(dvMa5AndClose > 6.f
                   || dvMa10AndClose < -8.f
                   ){
                    continue;
                }
                

                buyValue = kTP1Data.ma5 * 0.95;
                long bIndex = [HelpService indexOfValueSmallThan:buyValue Array:self.contentArray start:i+1 stop:i+4 kT0data:kT0Data];
                if(bIndex == -1){ //not find
                    continue;
                }
                
                kT0Data.TBuyData = [self.contentArray objectAtIndex:i+bIndex];
                
                
                CGFloat destValue = (1+self.destDVValue/100.f)*buyValue;
                long sIndex = [HelpService indexOfValueGreatThan:destValue Array:self.contentArray start:i+bIndex+1 stop:i+bIndex+3 kT0data:kT0Data];
                if(sIndex != -1){ //find
                    sellValue = (1+self.destDVValue/100.f)*buyValue;
                }else{
                    kT0Data.TSellData = [self.contentArray objectAtIndex:(i+bIndex+3)];
                    sellValue = kT0Data.TSellData.close;
                }

                
                [self dispatchResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            }
        }
   
    }
    
    
    
    if(self.totalCount > self.startLogCount){
        [[GSLogout shareManager] SimpleLogOutResult:NO];
    }
    
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
        
        
        
        kT0Data.T1Data = kT1Data;
        kT0Data.TP1Data = kTP1Data;
        
        kT0Data.dvTP2 = [[GSDataInit shareManager] getDVValue:self.contentArray baseIndex:i-3 destIndex:i-2];
        kT0Data.dvTP1 = [[GSDataInit shareManager] getDVValue:self.contentArray baseIndex:i-2 destIndex:i-1];
        kT0Data.dvT0 = [[GSDataInit shareManager] getDVValue:self.contentArray baseIndex:i-1 destIndex:i];
        kT0Data.dvT1 = [[GSDataInit shareManager] getDVValue:self.contentArray baseIndex:i destIndex:i+1];
        kT0Data.dvT2 = [[GSDataInit shareManager] getDVValue:self.contentArray baseIndex:i+1 destIndex:i+2];
        
        kT0Data.dvAvgTP1toTP5 = [[GSDataInit shareManager] getAvgDVValue:5 array:self.contentArray index:i-1];
        
        
        passDict = @{@"kTP6Data":kTP6Data, @"kTP5Data":kTP5Data, @"kTP4Data":kTP4Data,@"kTP3Data":kTP3Data, @"kTP2Data":kTP2Data, @"kTP1Data":kTP1Data,@"kT0Data":kT0Data, @"kT1Data":kT1Data};
        
        
        //dv condintoon
        if(![self isMeetDVConditon:self.tp2dayCond DVValue:kT0Data.dvTP2]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.tp1dayCond DVValue:kT0Data.dvTP1]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.t0dayCond DVValue:kT0Data.dvT0]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.t1dayCond DVValue:kT0Data.dvT1]){
            continue;
        }
        
        
        
        
        //shape condition
        if(![[GSCondition shareManager] isMeetShapeCond:passDict]){
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
    
    
    
    if(self.totalCount > self.startLogCount){
        [[GSLogout shareManager] logOutResult];
    }
    
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
        if(kTP2Data.dvT0.dvClose > -2.f
           && kTP1Data.dvT0.dvClose > -2.f
           && fabs(kT0Data.open - kT0Data.close) < 0.15f
           && kT0Data.dvT0.dvClose < 1.f)
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
    
    switch ([GSCondition shareManager].t0Cond) {
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








@end
