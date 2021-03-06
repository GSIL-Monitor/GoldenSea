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

#if 1
-(void)analysis
{
    NSArray* cxtArray = self.NSTKdayCxtArray;
    if(! [self isValidDataPassedIn] || [cxtArray count]< 3 )
    {
        return;
    }
//    
//    if([self.stkID isEqualToString:@"SH603313"]){
//        SMLog(@"");
//    }
    
    long statDays = 0, oneValDay=1;
    for(long i=1; i<[cxtArray count]-statDays;i++  ){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        CGFloat destValue = 0.f;
        
//        KDataModel* kTP4Data  = [cxtArray safeObjectAtIndex:(i-4)];
//        KDataModel* kTP3Data  = [cxtArray safeObjectAtIndex:(i-3)];
//        KDataModel* kTP2Data  = [cxtArray safeObjectAtIndex:(i-2)];
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
            if(!kT0Data.tradeDbg.isOpenLimit){ //if from yiZi, very danger.
                break;
            }
            
//            buyValue = kTP1Data.close*1.02;
            CGFloat bDVVal = 0.99;
            if(!kT0Data.tradeDbg.isOpenLimit){
                buyValue = kT0Data.open*bDVVal;
                if(kT0Data.open > 40.f){
                    buyValue = kT0Data.open*0.9;
                }
            }else{
                buyValue = kT0Data.open*0.9;
            }

            if(kT0Data.low > buyValue){
                break;
            }
          
            kT0Data.stkID = self.stkID;
            kT0Data.tradeDbg.oneValDay = oneValDay;
            kT0Data.tradeDbg.TBuyData = kT0Data;
            kT0Data.tradeDbg.isOpenLimit = [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.open];
            kT0Data.tradeDbg.pvLow2Op = kT0Data.low/kT0Data.open;
            kT0Data.tradeDbg.pvOp2TP1Close = kT0Data.open/kTP1Data.close;
            kT0Data.tradeDbg.pvHi2TP1Close = kT0Data.high/kTP1Data.close;
            kT0Data.tradeDbg.TP1Data = kTP1Data;
            
            destValue = (1+self.param.destDVValue/100.f)*buyValue;
            sellValue = [self getSellValue:buyValue  kT0data:kT0Data cxtArray:cxtArray start:i+1 stop:i+self.param.durationAfterBuy];
            
            
            if(kT0Data.tradeDbg.TSellData){
                if(destValue < kT1Data.open){
                    sellValue = kT1Data.open;
//                    SMLog(@"kt1Time:%ld,kT1Data.low:%.2f",kT1Data.time,kT1Data.low);
                }
                [self NSTKdispResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            }
            
            break;
        }
        
        oneValDay++;
    }
    
    
    [[GSObjMgr shareInstance].log SimpleLogOutResult:NO];
    
}

#else
-(void)analysis
{
    NSArray* cxtArray = self.NSTKdayCxtArray;
    if(! [self isValidDataPassedIn] || [cxtArray count]< 3 )
    {
        return;
    }
    //
    //    if([self.stkID isEqualToString:@"SH603313"]){
    //        SMLog(@"");
    //    }
    
    long statDays = 0, oneValDay=1;
    for(long i=1; i<[cxtArray count]-statDays;i++  ){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        CGFloat destValue = 0.f;
        
        //        KDataModel* kTP4Data  = [cxtArray safeObjectAtIndex:(i-4)];
        //        KDataModel* kTP3Data  = [cxtArray safeObjectAtIndex:(i-3)];
        //        KDataModel* kTP2Data  = [cxtArray safeObjectAtIndex:(i-2)];
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
            if(kT0Data.tradeDbg.isOpenLimit){ //if from yiZi, very danger.
                break;
            }
            
            
            [self findLowValDay:i days:5 lastOneValData:kTP1Data];
            
            
            
            break;
        }
        
        oneValDay++;
    }
    
    
    [[GSObjMgr shareInstance].log SimpleLogOutResult:NO];
    
}
#endif

-(void)findLowValDay:(long)startIndex days:(long)days lastOneValData:(KDataModel*)lastOneValData
{
    NSArray* cxtArray = self.NSTKdayCxtArray;

    CGFloat buyValue = 0.f;
    CGFloat sellValue = 0.f;
    CGFloat destValue = 0.f;
    
    //        KDataModel* kTP4Data  = [cxtArray safeObjectAtIndex:(i-4)];
    //        KDataModel* kTP3Data  = [cxtArray safeObjectAtIndex:(i-3)];
    //        KDataModel* kTP2Data  = [cxtArray safeObjectAtIndex:(i-2)];
//    KDataModel* kTP1Data  = [cxtArray safeObjectAtIndex:(i-1)];
//    KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
    long times = 0;
    
    for(long i=startIndex; i<[cxtArray count] && times++<days;i++  ){
        KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
        KDataModel* kT1Data = [cxtArray safeObjectAtIndex:(i+1)];

        if(kT0Data.low < lastOneValData.close*0.84){
            buyValue = lastOneValData.close*0.83;
            
            kT0Data.stkID = self.stkID;
//            kT0Data.tradeDbg.oneValDay = oneValDay;
            kT0Data.tradeDbg.TBuyData = kT0Data;
//            kT0Data.tradeDbg.isOpenLimit = [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.open];
//            kT0Data.tradeDbg.pvLow2Op = kT0Data.low/kT0Data.open;
//            kT0Data.tradeDbg.pvOp2TP1Close = kT0Data.open/kTP1Data.close;
//            kT0Data.tradeDbg.pvHi2TP1Close = kT0Data.high/kTP1Data.close;
//            kT0Data.tradeDbg.TP1Data = kTP1Data;
            
            destValue = (1+self.param.destDVValue/100.f)*buyValue;
            sellValue = [self getSellValue:buyValue  kT0data:kT0Data cxtArray:cxtArray start:i+1 stop:i+self.param.durationAfterBuy];
            
            
            if(kT0Data.tradeDbg.TSellData){
                if(destValue < kT1Data.open){
                    sellValue = kT1Data.open;
                }
                [self NSTKdispResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            }
            
            break;
            
        }else{
            //do nothing
        }
    }

}


@end
