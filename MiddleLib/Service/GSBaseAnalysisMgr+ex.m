//
//  GSBaseAnalysisMgr+ex.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseAnalysisMgr+ex.h"
#import "NewStkAnalysisMgr.h"



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


-(void)NSTKdispResult2Array:(KDataModel*)kT0data buyValue:(CGFloat)buyValue sellValue:(CGFloat)sellValue;
{
    NewStkAnalysisMgr* nstkMgr = (NewStkAnalysisMgr*)self;
    
    CGFloat dvValue = (sellValue-buyValue)*100.f/buyValue;

    nstkMgr.NSTKparam.totalS2BDVValue += dvValue;
    nstkMgr.NSTKparam.totalCount++;
    nstkMgr.NSTKparam.avgS2BDVValue = nstkMgr.NSTKparam.totalS2BDVValue/nstkMgr.NSTKparam.totalCount;
    
    kT0data.tradeDbg.dvSelltoBuy = dvValue;
    NSMutableArray* tmpArray = [nstkMgr.NSTKparam.resultArray objectAtIndex:0];
    [tmpArray addObject:kT0data];


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
        tmpArray = [self.param.resultArray objectAtIndex:0];
    }else if (dvValue > -1.5f){
        tmpArray = [self.param.resultArray objectAtIndex:1];
    }else {
        tmpArray = [self.param.resultArray objectAtIndex:2];
    }
    [tmpArray addObject:kT0data];
    self.param.totalS2BDVValue += dvValue;
    self.param.totalCount++;
    self.param.avgS2BDVValue = self.param.totalS2BDVValue/self.param.totalCount;
}


-(void)resetForOne
{
    self.dayCxtArray = [NSMutableArray array];
    self.weekCxtArray = [NSMutableArray array];
    self.monthCxtArray = [NSMutableArray array];

}

-(BOOL)isInRange:(NSString*)stkID;
{
    if(!self.stkRangeArray || ![self.stkRangeArray count]){
        return YES;
    }
    
    return [self.stkRangeArray containsObject:stkID];
    
}

-(BOOL)isInRange:(NSString*)stkID rangeArray:(NSArray*)rangeArray;
{
    if(!rangeArray || ![rangeArray count]){
        return YES;
    }
    
    return [rangeArray containsObject:stkID];

}


@end
