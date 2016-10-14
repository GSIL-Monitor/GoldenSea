//
//  TechAnalysisMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/9/28.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "TechAnalysisMgr.h"

@implementation TechAnalysisMgr

-(void)analysis //tbd.
{
    if(! [self isValidDataPassedIn] || [self.contentArray count]< 3 ) // || [self.contentArray count]<20)
    {
        return;
    }
    
    
    long statDays = 2;
    for(long i=4; i<[self.contentArray count]-statDays;  ){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        
        KDataModel* kTP4Data  = [self.contentArray safeObjectAtIndex:(i-4)];
        KDataModel* kTP3Data  = [self.contentArray safeObjectAtIndex:(i-3)];
        KDataModel* kTP2Data  = [self.contentArray safeObjectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [self.contentArray safeObjectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray safeObjectAtIndex:i];
        
        if(
           (kTP2Data.volume > kTP1Data.volume
           && kTP1Data.volume > kT0Data.volume
           && kTP3Data.volume > kTP2Data.volume
//           && kTP4Data.volume > kTP3Data.volume
           )
            &&
           (kTP2Data.close > kTP1Data.close
            && kTP1Data.close > kT0Data.close
            && kTP3Data.close > kTP2Data.close
            )
           )
        {
            if((kT0Data.time > 20150813 && kT0Data.time < 20150819)
               ||(kT0Data.time > 20150615 && kT0Data.time < 20150702)
               ||(kT0Data.time > 20151230 && kT0Data.time < 20160115)){
                i++;
                continue;
            }
            kT0Data.stkID = self.stkID;
            
            buyValue = kT0Data.close;
            
            kT0Data.tradeDbg.TBuyData = kT0Data;
            kT0Data.tradeDbg.TSellData = [self.contentArray safeObjectAtIndex:i+self.param.durationAfterBuy];
            
            
            sellValue = kT0Data.tradeDbg.TSellData.close;
            
            if(kT0Data.tradeDbg.TSellData)
                [self dispatchResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            
            
            
            
        }
        
        //increase i.
        if(kT0Data.tradeDbg.TSellData)
            i += self.param.durationAfterBuy+1;
        else
            i++;
        
    }
    
    
    [[GSObjMgr shareInstance].log SimpleLogOutResult:NO];
    
}

@end
