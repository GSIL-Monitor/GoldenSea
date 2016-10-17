//
//  GSBaseAnalysisMgr+ex.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseAnalysisMgr+ex.h"




@interface GSBaseAnalysisMgr ()
@end

@implementation GSBaseAnalysisMgr (ex)



-(BOOL)isValidDataPassedIn
{
    BOOL res = YES;
    
    if(self.currT0KData){
        if(!self.currTP1KData || !self.currTP2KData){
            res = NO;
        }
        
        if(self.currT0KData.open > kInvalidData_Base
           || self.currT0KData.close > kInvalidData_Base
           || self.currT0KData.high > kInvalidData_Base
           || self.currT0KData.low > kInvalidData_Base){
            res = NO;
        }
        
        if(self.currTP1KData.open > kInvalidData_Base
           || self.currTP1KData.close > kInvalidData_Base
           || self.currTP1KData.high > kInvalidData_Base
           || self.currTP1KData.low > kInvalidData_Base){
            res = NO;
        }
        
        
        if(self.currTP2KData.open > kInvalidData_Base
           || self.currTP2KData.close > kInvalidData_Base
           || self.currTP2KData.high > kInvalidData_Base
           || self.currTP2KData.low > kInvalidData_Base){
            res = NO;
        }
        
    }
    
    if(![self isValidDVCond:self.tp1dayCond]
       && ![self isValidDVCond:self.tp2dayCond]
       && ![self isValidDVCond:self.t0dayCond]
       && ![self isValidDVCond:self.t1dayCond]){
        res = NO;
    }
    
    if(!res){
        SMLog(@"the data is imcompleted!!!");
    }
    
    return res;
}


-(BOOL)isValidDVCond:(OneDayCondition*)dvCond
{
    if(!dvCond){
        return YES;
    }
    
    if(dvCond.open_max < dvCond.open_min){
        return NO;
    }
    
    if(dvCond.close_max < dvCond.close_min){
        return NO;
    }
    
    if(dvCond.high_max < dvCond.high_min){
        return NO;
    }
    
    if(dvCond.low_max < dvCond.low_min){
        return NO;
    }
    
    return YES;
}


-(void)dispatchResult2Array:(KDataModel*)kT0data buyIndex:(long)buyIndex sellIndex:(long)sellIndex
{
    long contentCount = [self.contentArray count];
    if(!kT0data
       || (sellIndex<0||sellIndex>contentCount-1)
       || (buyIndex<0||buyIndex>contentCount-1)
       || (buyIndex == sellIndex)){
        return;
    }
    
    
    
    KDataModel* sellData = [self.contentArray objectAtIndex:sellIndex];
    KDataModel* buyData = [self.contentArray objectAtIndex:buyIndex];
    CGFloat dvValue;
    
    //we don't know which is first appear for high or low. so only switch two case.
#if 0
    //case 1. judge with high
    if((sellData.high-buyData.close)/buyData.close*100.f >= self.param.destDVValue){
        dvValue = (sellData.close-buyData.close)*100.f/buyData.close;
    }else{
        dvValue = (sellData.close-buyData.close)*100.f/buyData.close;
    }
#else
    //case 2. judge with low
    if((sellData.low-buyData.close)/buyData.close*100.f <= self.param.cutDVValue){
        dvValue = self.param.cutDVValue;
//        dvValue = (sellData.close-buyData.close)*100.f/buyData.close;
    }else{
        dvValue = (sellData.close-buyData.close)*100.f/buyData.close;
    }
#endif
    
    [self _dispatchResult:kT0data dvValue:dvValue];

}


-(void)dispatchResult2Array:(KDataModel*)kT0data buyValue:(CGFloat)buyValue sellValue:(CGFloat)sellValue
{
    CGFloat dvValue = (sellValue-buyValue)*100.f/buyValue;
    
    [self _dispatchResult:kT0data dvValue:dvValue];
    
}


-(void)_dispatchResult:(KDataModel*)kT0data dvValue:(CGFloat)dvValue
{
    kT0data.tradeDbg.dvSelltoBuy = dvValue;
    
    NSMutableArray* tmpArray;

    
    //save to all.
    if (dvValue >= self.param.destDVValue-0.01){ //-0.01是为了float的精度问题
        tmpArray = [self.param.allResultArray objectAtIndex:0];
    }else if (dvValue > -1.5f){
        tmpArray = [self.param.allResultArray objectAtIndex:1];
    }else {
        tmpArray = [self.param.allResultArray objectAtIndex:2];
    }
    [tmpArray addObject:kT0data];
    self.param.allTotalS2BDVValue += dvValue;
    self.param.allTotalCount++;
    self.param.allAvgS2BDVValue = self.param.allTotalS2BDVValue/self.param.allTotalCount;
    
}


-(void)resetForOne
{
    self.contentArray = [NSMutableArray array];
}



-(BOOL)isInRange:(NSString*)stkID;
{
    if(!self.stkRangeArray || ![self.stkRangeArray count]){
        return YES;
    }
    
    return [self.stkRangeArray containsObject:stkID];

}


@end
