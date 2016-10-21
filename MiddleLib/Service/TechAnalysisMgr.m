//
//  TechAnalysisMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/9/28.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "TechAnalysisMgr.h"

@implementation TechAnalysisMgr


-(BOOL)isMapCondition:(long)i isQuery:(BOOL)isQuery
{
    NSArray* cxtArray = [self getCxtArray:self.period];

    KDataModel* kTP4Data  = [cxtArray safeObjectAtIndex:(i-4)];
    KDataModel* kTP3Data  = [cxtArray safeObjectAtIndex:(i-3)];
    KDataModel* kTP2Data  = [cxtArray safeObjectAtIndex:(i-2)];
    KDataModel* kTP1Data  = [cxtArray safeObjectAtIndex:(i-1)];
    KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
//    KDataModel* kT1Data = [cxtArray safeObjectAtIndex:(i+1)];
    
    
//    if([self.stkID isEqualToString:@"SH600019"]){
//        SMLog(@"");
//    }
    
//    if(kT0Data.time == 20160325){
//        SMLog(@"");
//    }
    
    BOOL volumeMap, isMap;
    long closeMap = 0, minCloseMapTimes = 3;
    if(isQuery){ //query, just check the last 2 days condition. today need check.
        minCloseMapTimes--;
        volumeMap = (kTP2Data.volume > kTP1Data.volume
                     && kTP1Data.volume > kT0Data.volume
                     //            && kTP3Data.volume > kTP2Data.volume
                     );
        
        closeMap =  ((kTP2Data.close > kTP1Data.close)
                     + (kTP1Data.close > kT0Data.close)
                     //            && kTP3Data.close > kTP2Data.close
                     );
      
    }else{
        volumeMap =
           (kTP2Data.volume > kTP1Data.volume
            && kTP1Data.volume > kT0Data.volume
            && kTP3Data.volume > kTP2Data.volume
//            && kTP4Data.volume > kTP3Data.volume
            );
                     
        closeMap =
        ((kTP2Data.close > kTP1Data.close )
            + (kTP1Data.close > kT0Data.close )
            + (kTP3Data.close > kTP2Data.close)
            );
    }
    
    if(self.period == Period_day){
        CGFloat downRate = kT0Data.volume/kTP1Data.volume;
        isMap = volumeMap && (closeMap>=minCloseMapTimes) && (downRate<0.75);
        
    }else{
        isMap = volumeMap;
    }
    

    return isMap;
}


-(BOOL)isMapWeekCondition:(KDataModel*)kT0Data //vid day
{
    CGFloat high=0.f,low=kInvalidData_Base, dvHigh2Low=0.f;
    CGFloat recentLow=kInvalidData_Base, dvRecentHigh2Low; //比如4周前的low值
//    CGFloat latestClose=0.f, agoClose=0.f, dvClose=0.f;
    BOOL find=NO;
    long units = 8; //8周振幅
    long weekIndex = 0;
    
    NSArray* weekArray = [self getCxtArray:Period_week];
    for(long i=[weekArray count]-1; i>=0; i--){
        KDataModel* tmpData = [weekArray safeObjectAtIndex:i];
        if(!find && ( tmpData.time <= kT0Data.time)){ //means find the week.
            find = YES;
            if(tmpData.time < kT0Data.time){
                weekIndex = i+1;
            }else{ //==
                weekIndex = i;
            }
            
//            break;
        }
        
        if(find){
            if(high < tmpData.high){
                high = tmpData.high;
            }
            
            if(low > tmpData.low){
                low = tmpData.low;
            }
            units--;
        }
        
        if(units==3){
            recentLow = low;
        }
        
        if(units <=0){
            break;
        }
    }
    
    if(find){
       
        KDataModel* kTP1WeekData = [weekArray safeObjectAtIndex:(weekIndex-1)];
        KDataModel* kTP6WeekData = [weekArray safeObjectAtIndex:(weekIndex-6)];
        kT0Data.tradeDbg.MA5weekT0toTP5 = kTP1WeekData.ma5/kTP6WeekData.ma5;
        kT0Data.tradeDbg.MA10weekT0toTP5 = kTP1WeekData.ma10/kTP6WeekData.ma10;
        
        dvHigh2Low = high/low;
        dvRecentHigh2Low = high/recentLow;
        CGFloat dvLastWeekHigh2Low = kTP1WeekData.high/kTP1WeekData.low;
//        if(
////           dvHigh2Low < 1.3
////           && dvRecentHigh2Low < 1.18
////           && dvLastWeekHigh2Low < 1.1
//           )
        
        if(kT0Data.tradeDbg.MA5weekT0toTP5  < 1.055
           && kT0Data.tradeDbg.MA10weekT0toTP5 < 1.025)
        {
            KDataModel* kT0WeekData = [weekArray safeObjectAtIndex:weekIndex];
//            KDataModel* kTP1WeekData = [weekArray safeObjectAtIndex:(weekIndex-1)];
            KDataModel* kTP2WeekData = [weekArray safeObjectAtIndex:(weekIndex-2)];
            if(kT0WeekData.volume > kTP1WeekData.volume
               && (kTP1WeekData.volume>kTP2WeekData.volume)
               && (kT0WeekData.ma20>kTP1WeekData.ma20)
               && (kT0WeekData.ma5>kTP1WeekData.ma5)){
                
         

                return YES;
            }
        }
    }
    
    return NO;
}

-(void)query
{
    NSArray* cxtArray = [self getCxtArray:self.period];

    //skip new stk.
    if([cxtArray count]<20){
        return;
    }
    
    long i = [cxtArray count]-1;
    
    BOOL isMap = [self isMapCondition:i isQuery:YES];
    if(isMap){
        [self.querySTKArray addObject:self.stkID];
    }
    
}



-(void)analysis
{
    NSArray* cxtArray = [self getCxtArray:self.period];
    if(! [self isValidDataPassedIn] || [cxtArray count]< 3 ) // || [cxtArray count]<20)
    {
        return;
    }
    
    long statDays = 0;
    for(long i=4; i<[cxtArray count]-statDays;  ){
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
           && [self isMapWeekCondition:kT0Data]
           )
        {
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
            buyValue = kT0Data.close;
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
                kT0Data.tradeDbg.MA5dayT0toTP5 = kTP1Data.ma5/kTP6Data.ma5;
                kT0Data.tradeDbg.MA10dayT0toTP5 = kTP1Data.ma10/kTP6Data.ma10;

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
