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
    
//    if([self.stkID isEqualToString:@"SH603608"]){
//        SMLog(@"");
//    }
    
    long statDays = 0, oneValDay=1;
    for(long i=1; i<[cxtArray count]-statDays;i++  ){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        CGFloat destValue = 0.f;
        
        KDataModel* kTP4Data  = [cxtArray safeObjectAtIndex:(i-4)];
        KDataModel* kTP3Data  = [cxtArray safeObjectAtIndex:(i-3)];
        KDataModel* kTP2Data  = [cxtArray safeObjectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [cxtArray safeObjectAtIndex:(i-1)];
        KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
        KDataModel* kT1Data = [cxtArray safeObjectAtIndex:(i+1)];
        
        
        if([self isOnePrice:kTP1Data]
           && ![self isOnePrice:kT0Data]
           )
        {
            if(oneValDay > 11){
                break;
            }
            
            if(kT0Data.open >80){
                break;
            }
            
            kT0Data.tradeDbg.isOpenLimit = [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.open];
            
//            buyValue = kTP1Data.close*1.02;
            if(!kT0Data.tradeDbg.isOpenLimit){
                buyValue = kT0Data.open*0.99;
            }else{
                buyValue = kT0Data.open*0.92;
            }

            if(kT0Data.low > buyValue){
                break;
            }
          
            kT0Data.stkID = self.stkID;
            kT0Data.tradeDbg.oneValDay = oneValDay;
            kT0Data.tradeDbg.TBuyData = kT0Data;
            kT0Data.tradeDbg.isOpenLimit = [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.open];
            
            destValue = (1+self.param.destDVValue/100.f)*buyValue;
            sellValue = [self getSellValue:buyValue  kT0data:kT0Data cxtArray:cxtArray start:i+1 stop:i+self.param.durationAfterBuy];
            
            
            if(kT0Data.tradeDbg.TSellData){
                if(destValue < kT1Data.open){
                    sellValue = kT1Data.open;
                    SMLog(@"kt1Time:%ld,kT1Data.low:%.2f",kT1Data.time,kT1Data.low);
                }
                [self NSTKdispResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            }
            
            break;
        }
        
        oneValDay++;
    }
    
    
    [[GSObjMgr shareInstance].log SimpleLogOutResult:NO];
    
}




@end
