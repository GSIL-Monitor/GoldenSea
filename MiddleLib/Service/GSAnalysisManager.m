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


@property (nonatomic,strong) NSArray* contentArray;


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
        
        if(![self isMeetWaibaoriDown:kTP2Data NextData:kTP1Data]){
            continue;
        }
        
        if(![self isMeetMutableCond:kTP1Data NextData:kT0Data]){
            continue;
        }
        
        
        [self dispatchResult2Array:kT0Data];
        
        self.totalCount++;
    }
    
    [[GSLogout shareManager] logOutResult];
    
    

}


#pragma mark - internal funcs


-(void)reset
{
    self.totalCount = 0;
    self.contentArray = [NSMutableArray array];
    self.resultArray = [NSMutableArray array];
    
    /*
     Sndday high vs fstday close
     >3%
     >1%
     >0%
     >-1.5%
     >-10%
     */
    for(long i=0; i<5; i++){
        [self.resultArray addObject:[NSMutableArray array]];
    }
}

-(void)dispatchResult2Array:(KDataModel*)kSndData
{
    CGFloat dvValue = kSndData.dvT0.dvHigh;
//    CGFloat dvUnit = 1.f;
    NSMutableArray* tmpArray;
    if(dvValue > 3.f){
        tmpArray = [self.resultArray objectAtIndex:0];
    }else if (dvValue > 1.f){
        tmpArray = [self.resultArray objectAtIndex:1];
    }else if (dvValue > 0.f){
        tmpArray = [self.resultArray objectAtIndex:2];
    }else if (dvValue > -1.5f){
        tmpArray = [self.resultArray objectAtIndex:3];
    }else if (dvValue > -11.f){
        tmpArray = [self.resultArray objectAtIndex:4];
    }
    
    [tmpArray addObject:kSndData];
}





#pragma mark - condition


-(BOOL)isMeetMutableCond:(KDataModel*)kPrevData NextData:(KDataModel*)kNextData
{
    
    if(kNextData.open < kPrevData.low){
        return YES;
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
    }else{
        //do nothing.
//        int r = 1;
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
