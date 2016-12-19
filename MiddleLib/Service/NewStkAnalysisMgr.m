//
//  NewStkAnalysisMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/12/15.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "NewStkAnalysisMgr.h"
#import "RaisingLimitParam.h"

@interface NewStkAnalysisMgr ()

@property (nonatomic, strong) RaisingLimitParam* param;

@end


@implementation NewStkAnalysisMgr

-(BOOL)isMapCondition:(long)i isQuery:(BOOL)isQuery
{
    BOOL map=NO;
    
    NSArray* cxtArray = [self getCxtArray:self.period];
    
    KDataModel* kTP10Data  = [cxtArray safeObjectAtIndex:(i-10)];
    KDataModel* kTP5Data  = [cxtArray safeObjectAtIndex:(i-5)];
    KDataModel* kTP4Data  = [cxtArray safeObjectAtIndex:(i-4)];
    KDataModel* kTP3Data  = [cxtArray safeObjectAtIndex:(i-3)];
    KDataModel* kTP2Data  = [cxtArray safeObjectAtIndex:(i-2)];
    KDataModel* kTP1Data  = [cxtArray safeObjectAtIndex:(i-1)];
    KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
    
    if(kT0Data.low < kTP1Data.ma20
       && kTP1Data.ma20 > kTP5Data.ma20){
        map = YES;
    }
    
    
    return map;
}


-(BOOL)isNewSTK
{
    BOOL map=YES;
    NSArray* cxtArray = [self getCxtArray:self.period];

    long i = 4;
    
    KDataModel* kT4Data  = [cxtArray safeObjectAtIndex:(i+4)];
    KDataModel* kT3Data  = [cxtArray safeObjectAtIndex:(i+3)];
    KDataModel* kT2Data  = [cxtArray safeObjectAtIndex:(i+2)];
    KDataModel* kT1Data  = [cxtArray safeObjectAtIndex:(i+1)];
    KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
    
    for(long i =0; i<4; i++){
        KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
        
        if(![HelpService isEqual:kT0Data.high with:kT0Data.low]){
            map = NO;
            break;
        }
    }
    
    return map;
}

-(void)analysis
{
    NSArray* cxtArray = [self getCxtArray:self.period];
    if(! [self isValidDataPassedIn] || [cxtArray count]< 3 )
    {
        return;
    }
    
    long statDays = 0;
    for(long i=12; i<[cxtArray count]-statDays;  ){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        
        KDataModel* kTP4Data  = [cxtArray safeObjectAtIndex:(i-4)];
        KDataModel* kTP3Data  = [cxtArray safeObjectAtIndex:(i-3)];
        KDataModel* kTP2Data  = [cxtArray safeObjectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [cxtArray safeObjectAtIndex:(i-1)];
        KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
        //        KDataModel* kT1Data = [cxtArray safeObjectAtIndex:(i+1)];
        
        
        //        if(kT0Data.time == 20160527){
        //            NSLog(@"");
        //        }`
        
        if([self isMapCondition:i isQuery:NO]
           //           && [self isMapWeekCondition:kT0Data]
           )
        {
            if(kT0Data.time < 20160301 && kT0Data.time>20160201){
                i++;
                continue;
            }
            
            if(Period_day == self.period){
                //                if((kT0Data.time > 20150813 && kT0Data.time < 20150819)
                //                   ||(kT0Data.time > 20150615 && kT0Data.time < 20150702)
                //                   ||(kT0Data.time > 20151230 && kT0Data.time < 20160115)){
                //                    i++;
                //                    continue;
                //                }
            }
            
            kT0Data.stkID = self.stkID;
            
#if 1
            buyValue = kTP1Data.ma20;
            kT0Data.tradeDbg.TBuyData = kT0Data;
            
            sellValue = [self getSellValue:buyValue  kT0data:kT0Data cxtArray:cxtArray start:i+1 stop:i+self.param.durationAfterBuy];
#endif
            
            //case 2
#if 0
            buyValue = kT1Data.open;
            kT0Data.tradeDbg.TBuyData = kT1Data;
            
            sellValue = [self getSellValue:buyValue  kT0data:kT0Data cxtArray:cxtArray start:i+1+1 stop:i+1+self.param.durationAfterBuy];
#endif
            
            
            if(kT0Data.tradeDbg.TSellData){
                KDataModel* kTP6Data  = [cxtArray safeObjectAtIndex:(i-6)];
                kT0Data.tradeDbg.dMA5Slope = kTP1Data.ma5/kTP6Data.ma5;
                kT0Data.tradeDbg.dMA10Slope = kTP1Data.ma10/kTP6Data.ma10;
                
                [self dispatchResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            }
        }
        
        //increase i.
        if(kT0Data.tradeDbg.TSellData)
            i = kT0Data.tradeDbg.TSellDataIndex+1; //
        else
            i++;
        
    }
    
    
    [[GSObjMgr shareInstance].log SimpleLogOutResult:NO];
    
}




@end
