//
//  GSAnalysisManager+ex.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSAnalysisManager+ex.h"

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
    
    if(!res){
        SMLog(@"the data is imcompleted!!!");
    }
    
    return res;
}


-(void)dispatchResult2Array:(KDataModel*)kT0data buy:(CGFloat)buyValue sell:(CGFloat)sellValue
{
    CGFloat dvValue = (sellValue-buyValue)*100.f/buyValue;
    
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
    
    [tmpArray addObject:kT0data];
}


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




//
//-(void)dispatchResult2Array:(KDataModel*)kSndData
//{
//    CGFloat dvValue = kSndData.dvT0.dvHigh;
//    //    CGFloat dvUnit = 1.f;
//    NSMutableArray* tmpArray;
//    if(dvValue > 3.f){
//        tmpArray = [self.resultArray objectAtIndex:0];
//    }else if (dvValue > 1.f){
//        tmpArray = [self.resultArray objectAtIndex:1];
//    }else if (dvValue > 0.f){
//        tmpArray = [self.resultArray objectAtIndex:2];
//    }else if (dvValue > -1.5f){
//        tmpArray = [self.resultArray objectAtIndex:3];
//    }else if (dvValue > -11.f){
//        tmpArray = [self.resultArray objectAtIndex:4];
//    }
//    
//    [tmpArray addObject:kSndData];
//}
//
//
//-(void)dispatchResult2Array:(KDataModel*)KT0Data T1:(KDataModel*)kT1Data
//{
//    CGFloat dvValue = (kT1Data.high-KT0Data.open)*100.f/KT0Data.open;
//    //    CGFloat dvUnit = 1.f;
//    NSMutableArray* tmpArray;
//    if(dvValue > 3.f){
//        tmpArray = [self.resultArray objectAtIndex:0];
//    }else if (dvValue > 1.f){
//        tmpArray = [self.resultArray objectAtIndex:1];
//    }else if (dvValue > 0.f){
//        tmpArray = [self.resultArray objectAtIndex:2];
//    }else if (dvValue > -1.5f){
//        tmpArray = [self.resultArray objectAtIndex:3];
//    }else if (dvValue > -11.f){
//        tmpArray = [self.resultArray objectAtIndex:4];
//    }
//    
//    [tmpArray addObject:KT0Data];
//}
//



@end
