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

@interface GSAnalysisManager ()


@end


@implementation GSAnalysisManager

SINGLETON_GENERATOR(GSAnalysisManager, shareManager);


-(id)init
{
    if(self = [super init]){
    }
    
    return self;
}


-(void)analysisFile:(NSString*)stkUUID inDir:(NSString*)docsDir
{
    //reset content when every time read file.
    [self reset];
    
    
    self.contentArray = [[GSDataInit shareManager] buildDataWithStkUUID:stkUUID inDir:docsDir];
    
    [self analysis];
}

-(void)analysis
{
    self.totalCount=0;
    
    if(! [self isValidDataPassedIn]){
        return;
    }
    
    
//    for(long i=0; i<[self.contentArray count]-1; i++ ){
    
    for(long i=6; i<[self.contentArray count]-2; i++ ){
        KDataModel* kTP6Data  = [self.contentArray objectAtIndex:(i-6)];
        KDataModel* kTP5Data  = [self.contentArray objectAtIndex:(i-5)];
        KDataModel* kTP4Data  = [self.contentArray objectAtIndex:(i-4)];
        KDataModel* kTP3Data  = [self.contentArray objectAtIndex:(i-3)];
        KDataModel* kTP2Data  = [self.contentArray objectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [self.contentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i];
        KDataModel* kT1Data = [self.contentArray objectAtIndex:i+1];
        
        
        if(![self isMeetConditon:self.tp1dayCond DVValue:kT0Data.dvTP1]){
            continue;
        }
        
        
        if(![self isMeetConditon:self.t0dayCond DVValue:kT0Data.dvT0]){
            continue;
        }
        
//        if(![self isMeetWaibaoriDown:kTP2Data NextData:kTP1Data]){
//            continue;
//        }
//        
//        if(![self isMeetMutableCond:kTP1Data NextData:kT0Data]){
//            continue;
//        }
        
        

        [self dispatchResult2Array:kT0Data buy:kT0Data.close sell:kT1Data.high];
        
//        [self dispatchResult2Array:kT0Data buy:kT0Data.low sell:kT1Data.high];


//        [self dispatchResult2Array:kT0Data buy:kT0Data.open sell:kT1Data.high];
        
        self.totalCount++;
    }
    
    [[GSLogout shareManager] logOutResult];
    
    
}


#pragma mark - internal funcs





#pragma mark - condition


-(BOOL)isMeetMutableCond:(KDataModel*)kPrevData NextData:(KDataModel*)kNextData
{
    
    if(kNextData.open < kPrevData.low){
//        if((kPrevData.dvT0.dvClose > -5.5)
//        && (kNextData.dvT0.dvOpen > -2.f)
//           )
        {
            return YES;
        }
    }
    
    
    
    return NO;
}


-(BOOL)isMeetWaibaoriDown:(KDataModel*)kPrevData NextData:(KDataModel*)kNextData
{
    if(!self.isWaibaoriDownCond){
        return YES;
    }
    
    if(kNextData.high > kPrevData.high
       && kNextData.low < kPrevData.low
       && kNextData.open > kNextData.close){
        return YES;
    }
    
    return NO;
}



-(BOOL)isMeetConditon:(OneDayCondition*)cond DVValue:(DVValue*)dv;
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
