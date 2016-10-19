//
//  TechAnalysisMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/9/28.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "TechAnalysisMgr.h"

@implementation TechAnalysisMgr

-(BOOL)isMapCondition:(long)i
{
    KDataModel* kTP4Data  = [self.contentArray safeObjectAtIndex:(i-4)];
    KDataModel* kTP3Data  = [self.contentArray safeObjectAtIndex:(i-3)];
    KDataModel* kTP2Data  = [self.contentArray safeObjectAtIndex:(i-2)];
    KDataModel* kTP1Data  = [self.contentArray safeObjectAtIndex:(i-1)];
    KDataModel* kT0Data = [self.contentArray safeObjectAtIndex:i];
    KDataModel* kT1Data = [self.contentArray safeObjectAtIndex:(i+1)];
    
    
    if([self.stkID isEqualToString:@"SH600019"]){
        SMLog(@"");
    }
    
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
       ){
        return YES;
    }
    
    
    return NO;
}

-(void)query
{
    //skip new stk.
    if([self.contentArray count]<20){
        return;
    }
    
    long i = [self.contentArray count]-1;
    {
//        KDataModel* kTP4Data  = [self.contentArray safeObjectAtIndex:(i-4)];
//        KDataModel* kTP3Data  = [self.contentArray safeObjectAtIndex:(i-3)];
//        KDataModel* kTP2Data  = [self.contentArray safeObjectAtIndex:(i-2)];
//        KDataModel* kTP1Data  = [self.contentArray safeObjectAtIndex:(i-1)];
//        KDataModel* kT0Data = [self.contentArray safeObjectAtIndex:i];
//        KDataModel* kT1Data = [self.contentArray safeObjectAtIndex:(i+1)];
        
        
        BOOL isMap = [self isMapCondition:i];
        if(isMap){
            [self.querySTKArray addObject:self.stkID];
        }
    }
    
    
}



-(void)analysis
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
        KDataModel* kT1Data = [self.contentArray safeObjectAtIndex:(i+1)];

        
        if(kT0Data.time == 20160527){
            NSLog(@"");
        }
        
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
            
#if 0
            buyValue = kT0Data.close;
            kT0Data.tradeDbg.TBuyData = kT0Data;
            
            sellValue = [self getSellValue:buyValue  kT0data:kT0Data start:i+1 stop:i+self.param.durationAfterBuy];
#endif
            
            //case 2
#if 1
            buyValue = kT1Data.open;
            kT0Data.tradeDbg.TBuyData = kT1Data;
            
            sellValue = [self getSellValue:buyValue  kT0data:kT0Data start:i+1+1 stop:i+1+self.param.durationAfterBuy];
#endif
            
            
            if(kT0Data.tradeDbg.TSellData){
                [self dispatchResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            }
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
