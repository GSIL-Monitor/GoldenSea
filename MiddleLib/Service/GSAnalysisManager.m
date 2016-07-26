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

-(void)analysisFile:(NSString*)stkUUID inDir:(NSString*)docsDir;
{
    [GSDataInit shareManager].startDate = 20110101;
    [GSDataInit shareManager].endDate = 20120101;
    [self _analysisFile:stkUUID inDir:docsDir];

    [GSDataInit shareManager].startDate = 20120101;
    [GSDataInit shareManager].endDate = 20130101;
    [self _analysisFile:stkUUID inDir:docsDir];


    [GSDataInit shareManager].startDate = 20140101;
    [GSDataInit shareManager].endDate = 20150101;
    [self _analysisFile:stkUUID inDir:docsDir];


    [GSDataInit shareManager].startDate = 20150101;
    [GSDataInit shareManager].endDate = 20160101;
    [self _analysisFile:stkUUID inDir:docsDir];


    [GSDataInit shareManager].startDate = 20160101;
    [GSDataInit shareManager].endDate = 20170101;
    [self _analysisFile:stkUUID inDir:docsDir];
    
//    [self _analysisFile:stkUUID inDir:docsDir];


}

-(void)_analysisFile:(NSString*)stkUUID inDir:(NSString*)docsDir
{
    //reset content when every time read file.
    [self reset];
    
    self.stkID = stkUUID;
    
    
    self.contentArray = [[GSDataInit shareManager] buildDataWithStkUUID:stkUUID inDir:docsDir];
    
    //        [self analysis];
    [self analysisForRaisingLimit];
    
}

-(void)analysisAllInDir:(NSString*)docsDir;
{
    self.startLogCount = 2;
    
    NSMutableArray* files = [[GSDataInit shareManager]findSourcesInDir:docsDir];
    for(NSString* file in files){
        [self reset];
        self.stkID = [file lastPathComponent];
        
        self.contentArray = [[GSDataInit shareManager] getStkContentArray:file];
        
//        [self analysis];
        [self analysisForRaisingLimit];

    }
    
    
    [[GSLogout shareManager]logOutStatResult];
}

-(void)analysis
{
    self.totalCount=0;
    
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
        
        kT0Data.ma5 = [[GSDataInit shareManager] getMAValue:5 array:self.contentArray t0Index:i];
        kT0Data.ma10 = [[GSDataInit shareManager] getMAValue:10 array:self.contentArray t0Index:i];
        kT0Data.ma20 = [[GSDataInit shareManager] getMAValue:20 array:self.contentArray t0Index:i];
        kT0Data.ma30 = [[GSDataInit shareManager] getMAValue:30 array:self.contentArray t0Index:i];
        
            
           

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
        
        self.totalCount++;
    }
    
    
    
    if(self.totalCount > self.startLogCount){
        [[GSLogout shareManager] logOutResult];
    }
    
}




-(void)analysisForRaisingLimit
{
    self.totalCount=0;
    
    if(! [self isValidDataPassedIn] || [self.contentArray count]<20){
        return;
    }
    
    NSDictionary* passDict;
    for(long i=6; i<[self.contentArray count]-9; i++ ){
        
        KDataModel* kTP1Data  = [self.contentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i];
        KDataModel* kT1Data = [self.contentArray objectAtIndex:i+1];
        KDataModel* kT4Data = [self.contentArray objectAtIndex:i+4];
        KDataModel* kT5Data = [self.contentArray objectAtIndex:i+5];
        
        kT0Data.lowValDayIndex = 1;
        kT0Data.highValDayIndex = 5;
        
        if([HelpService isRasingLimitValue:kTP1Data.close T0Close:kT0Data.close]){
            kT0Data.dvT1 = [[GSDataInit shareManager] getDVValue:self.contentArray baseIndex:i destIndex:i+1];

            if(kT0Data.dvT1.dvClose < 0.f){
                
                CGFloat theLowestValue = kT1Data.low;
                CGFloat theHighestValue = kT5Data.high;

                
                //check t1-4 low
                for(long j=i+1; j<i+5; j++){
                    KDataModel* tempData = [self.contentArray objectAtIndex:j];
                    if(tempData.low < theLowestValue){
                        theLowestValue = tempData.low;
                        kT0Data.lowValDayIndex = j-i;
                    }
                }
                
                //check t5-8 high
                for(long j=i+5; j<i+9; j++){
                    KDataModel* tempData = [self.contentArray objectAtIndex:j];
                    if(tempData.high > theHighestValue){
                        theHighestValue = tempData.high;
                        kT0Data.highValDayIndex = j-i;
                    }
                }
                
                if(theLowestValue > kT0Data.low){
                    continue;
                }
                
                
                //filter up much in shorttime
                kTP1Data.ma5 = [[GSDataInit shareManager] getMAValue:5 array:self.contentArray t0Index:i-1];
                kTP1Data.ma10 = [[GSDataInit shareManager] getMAValue:10 array:self.contentArray t0Index:i-1];
                CGFloat dvMa5AndClose = [[GSDataInit shareManager]getDVValueWithBaseValue:kTP1Data.ma5 destValue:kTP1Data.close];
                CGFloat dvMa10AndClose = [[GSDataInit shareManager]getDVValueWithBaseValue:kTP1Data.ma10 destValue:kTP1Data.close];

                if(dvMa5AndClose > 5.f || dvMa10AndClose < -8.f){
                    continue;
                }
                
                
                CGFloat buyValue = kT0Data.low;
                if(kT4Data.close < kT0Data.low){
                    buyValue = kT4Data.close;
                }
                [self _dispatchResult2Array:kT0Data buy:buyValue sell:theHighestValue];
                
                
                self.totalCount++;

            }
        }
   
    }
    
    
    
    if(self.totalCount > self.startLogCount){
        [[GSLogout shareManager] SimpleLogOutResult:NO];
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
           && fabsf(kT0Data.open - kT0Data.close) < 0.15f
           && kT0Data.dvT0.dvClose < 1.f)
        return YES;
    }
    
//    if((kT0Data.low - kT1Data.low > -0.1)
//    && (kT0Data.close - kT0Data.low < 0.1)){
//        return YES;
//    }
    
//    if(kT0Data.close - kT0Data.low < 0.1){
//        return YES;
//    }

    //        CGFloat wantBuy = kT0Data.close*0.97;
    //        if(wantBuy < kT1Data.low){
    //            continue;
    //        }
    //
//    if(kT1Data.dvT0.dvClose - kT1Data.dvT0.dvLow > 1.f){
//        return NO;
//    }
//    
//    if(!(kT1Data.dvT0.dvLow < -1 && kT1Data.dvT0.dvLow > -2)){
//        return NO;
//    }
    
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
