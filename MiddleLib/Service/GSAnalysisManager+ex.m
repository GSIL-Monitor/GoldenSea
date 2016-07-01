//
//  GSAnalysisManager+ex.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSAnalysisManager+ex.h"


@interface GSAnalysisManager ()
@end

@implementation GSAnalysisManager (ex)



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
    if((sellData.high-buyData.close)/buyData.close*100.f >= self.destDVValue){
//        dvValue = self.destDVValue;
        dvValue = (sellData.close-buyData.close)*100.f/buyData.close;
    }else{
        dvValue = (sellData.close-buyData.close)*100.f/buyData.close;
    }
#else
    //case 2. judge with low
    if((sellData.low-buyData.close)/buyData.close*100.f <= self.stopDVValue){
        dvValue = self.stopDVValue;
//        dvValue = (sellData.close-buyData.close)*100.f/buyData.close;
    }else{
        dvValue = (sellData.close-buyData.close)*100.f/buyData.close;
    }
#endif
    
    [self _calculateResult:kT0data dvValue:dvValue];

}


-(void)_dispatchResult2Array:(KDataModel*)kT0data buy:(CGFloat)buyValue sell:(CGFloat)sellValue
{
    CGFloat dvValue = (sellValue-buyValue)*100.f/buyValue;
    
    [self _calculateResult:kT0data dvValue:dvValue];
    
}


-(void)_calculateResult:(KDataModel*)kT0data dvValue:(CGFloat)dvValue
{
    kT0data.dvSelltoBuy = dvValue;
    
    //    CGFloat dvUnit = 1.f;
    NSMutableArray* tmpArray;
    //    if(dvValue > 3.f){
    //        tmpArray = [self.resultArray objectAtIndex:0];
    //    }else if (dvValue >= self.destDVValue){
    //        tmpArray = [self.resultArray objectAtIndex:1];
    //    }else if (dvValue > -1.5f){
    //        tmpArray = [self.resultArray objectAtIndex:2];
    //    }else if (dvValue > -11.f){
    //        tmpArray = [self.resultArray objectAtIndex:3];
    //    }
    
    if (dvValue >= self.destDVValue){
        tmpArray = [self.resultArray objectAtIndex:0];
    }else if (dvValue > -1.5f){
        tmpArray = [self.resultArray objectAtIndex:1];
    }else if (dvValue > -11.f){
        tmpArray = [self.resultArray objectAtIndex:2];
    }
    
    self.segIndex = 1;
    
    [tmpArray addObject:kT0data];
    
    self.totalS2BDVValue += dvValue;
    
    
    
}


-(void)reset
{
    self.totalCount = 0;
    self.contentArray = [NSMutableArray array];
    self.resultArray = [NSMutableArray array];
    
    /*
     Sndday high vs fstday close
     >3%
     >0.8%
     >-1.5%
     >-10%
     */
    for(long i=0; i<4; i++){
        [self.resultArray addObject:[NSMutableArray array]];
    }
}





@end
