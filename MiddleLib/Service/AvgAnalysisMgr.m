//
//  AvgAnalysisMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/22.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "AvgAnalysisMgr.h"

@implementation AvgAnalysisMgr


-(void)analysis //tbd.
{
    if(! [self isValidDataPassedIn] || [self.contentArray count]< 3 ) // || [self.contentArray count]<20)
    {
        return;
    }
    
    
    long statDays = 2;
    long middleIndex = 7;
    for(long i=1; i<[self.contentArray count]-statDays; i++ ){
        CGFloat buyValue = 0.f;
        CGFloat sellValue = 0.f;
        
        KDataModel* kTP1Data  = [self.contentArray safeObjectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray safeObjectAtIndex:i];
        
//        if(kT0Data.isLimitUp)
        {
            if((kT0Data.time > 20150813 && kT0Data.time < 20150819)
               ||(kT0Data.time > 20150615 && kT0Data.time < 20150702)
               ||(kT0Data.time > 20151230 && kT0Data.time < 20160115)){
                continue;
            }
            kT0Data.stkID = self.stkID;
            
            buyValue = kTP1Data.ma5 * 1.f+0.1; //self.param.buyPercent;
            long bIndex = [HelpService indexOfValueSmallThan:buyValue Array:self.contentArray start:i stop:i kT0data:kT0Data];
            if(bIndex == -1){ //not find
                continue;
            }
            
//            kT0Data.TBuyData = [self.contentArray objectAtIndex:i];
            
            sellValue = [self getSellValue:buyValue bIndexInArray:i+1 kT0data:kT0Data];
            
            if(kT0Data.TSellData)
                [self dispatchResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            
            
        }
        
    }
    
    
    [[GSObjMgr shareInstance].log SimpleLogOutResult:NO];
    
}


@end
