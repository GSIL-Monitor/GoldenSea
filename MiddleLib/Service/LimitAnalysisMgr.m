//
//  LimitAnalysisMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "LimitAnalysisMgr.h"

@implementation LimitAnalysisMgr

-(void)analysisAllInDir:(NSString*)docsDir;
{
    
    [super analysisAllInDir:docsDir];
    
}



-(void)analysis
{
    if(! [self isValidDataPassedIn] || [self.contentArray count]<20){
        return;
    }
    
    
    NSDictionary* passDict;
    long statDays = 2;
    long middleIndex = 7;
    for(long i=6; i<[self.contentArray count]-statDays; i++ ){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        
        KDataModel* kTP1Data  = [self.contentArray safeObjectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray safeObjectAtIndex:i];
        //        KDataModel* kT1Data = [self.contentArray safeObjectAtIndex:i+1];
        //        KDataModel* kT2Data = [self.contentArray safeObjectAtIndex:i+2];
        //        KDataModel* kT3Data = [self.contentArray safeObjectAtIndex:i+3];
        //        KDataModel* kT4Data = [self.contentArray safeObjectAtIndex:i+4];
        //        KDataModel* kT5Data = [self.contentArray safeObjectAtIndex:i+5];
        //        KDataModel* kT6Data = [self.contentArray safeObjectAtIndex:i+6];
        //        KDataModel* kT7Data = [self.contentArray safeObjectAtIndex:i+7];
        //        KDataModel* kT8Data = [self.contentArray safeObjectAtIndex:i+8];
        //        KDataModel* kT9Data = [self.contentArray safeObjectAtIndex:i+9];
        
        
        kT0Data.lowValDayIndex = 1;
        kT0Data.highValDayIndex = 5;
        
        if(kT0Data.isLimitUp){
            if((kT0Data.time > 20150813 && kT0Data.time < 20150819)
               ||(kT0Data.time > 20150615 && kT0Data.time < 20150702)
               ||(kT0Data.time > 20151230 && kT0Data.time < 20160115)){
                continue;
            }
            kT0Data.stkID = self.stkID;
            
            
            if(self.param.daysAfterLastLimit == 0)
            {
                //filter raise much in shorttime
                if(![self.param isMapRasingLimitAvgConditon:kTP1Data]){
                    continue;
                }
                
                buyValue = kTP1Data.ma5 * self.param.buyPercent;
                long bIndex = [HelpService indexOfValueSmallThan:buyValue Array:self.contentArray start:i+1 stop:i+4 kT0data:kT0Data];
                if(bIndex == -1){ //not find
                    continue;
                }
                
                kT0Data.TBuyData = [self.contentArray objectAtIndex:i+bIndex];
                
                
                sellValue = [self getSellValue:buyValue bIndexInArray:i+bIndex kT0data:kT0Data];
                
                if(kT0Data.TSellData)
                    [self dispatchResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            }
            else
            {
                //filter raise much in shorttime
                if(![self.param isMapRasingLimitAvgConditonMa30:kTP1Data]){
                    continue;
                }
                
                if(![self.param isNoLimitInLastDaysBeforeIndex:i contentArray:self.contentArray]){
                    continue;
                }
                
#if 0
                long bIndex = 2;
                kT0Data.TBuyData = [self.contentArray safeObjectAtIndex:i+bIndex];
                buyValue = kT0Data.TBuyData.close;
#else
                buyValue = kTP1Data.ma5 * self.param.buyPercent;
                long bIndex = [HelpService indexOfValueSmallThan:buyValue Array:self.contentArray start:i+1 stop:i+4 kT0data:kT0Data];
                if(bIndex == -1){ //not find
                    continue;
                }
#endif
                
                kT0Data.TBuyData = [self.contentArray objectAtIndex:i+bIndex];
                
                sellValue = [self getSellValue:buyValue bIndexInArray:i+bIndex kT0data:kT0Data];
                
                if(kT0Data.TSellData)
                    [self dispatchResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            }
        }
        
    }
    
    
    [[LimitLogout shareInstance] SimpleLogOutResult:NO];
    
}


@end
