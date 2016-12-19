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



-(BOOL)isOnePrice:(KDataModel*) kT0Data
{
    return [HelpService isEqual:kT0Data.high with:kT0Data.low];
}

-(void)analysis
{
    NSArray* cxtArray = self.NSTKdayCxtArray;
    if(! [self isValidDataPassedIn] || [cxtArray count]< 3 )
    {
        return;
    }
    
    long statDays = 0, oneValDay=0;
    for(long i=0; i<[cxtArray count]-statDays;i++  ){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        
        KDataModel* kTP4Data  = [cxtArray safeObjectAtIndex:(i-4)];
        KDataModel* kTP3Data  = [cxtArray safeObjectAtIndex:(i-3)];
        KDataModel* kTP2Data  = [cxtArray safeObjectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [cxtArray safeObjectAtIndex:(i-1)];
        KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
        //KDataModel* kT1Data = [cxtArray safeObjectAtIndex:(i+1)];
        
        
        if([self isOnePrice:kTP1Data]
           && ![self isOnePrice:kT0Data]
           )
        {
//            if(kT0Data.time < 20160301 && kT0Data.time>20160201){
//                i++;
//                continue;
//            }
            buyValue = kTP1Data.close*1.02;

            if(kT0Data.low > buyValue){
                break;
            }
          
            kT0Data.stkID = self.stkID;
            kT0Data.tradeDbg.oneValDay = oneValDay;
            kT0Data.tradeDbg.TBuyData = kT0Data;
            
            sellValue = [self getSellValue:buyValue  kT0data:kT0Data cxtArray:cxtArray start:i+1 stop:i+self.param.durationAfterBuy];
            
            
            if(kT0Data.tradeDbg.TSellData){
                [self dispatchResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            }
            
            break;
        }
        
        oneValDay++;
    }
    
    
    [[GSObjMgr shareInstance].log SimpleLogOutResult:NO];
    
}




@end
