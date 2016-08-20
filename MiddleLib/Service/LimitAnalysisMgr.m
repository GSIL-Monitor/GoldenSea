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



-(void)query
{
    //skip new stk.
    if([self.contentArray count]<20){
        return;
    }
    
    NSMutableArray* queryArray = [NSMutableArray array];
    
    //    SMLog(@"stkID:%@",self.stkID);
    long lastIndex = [self.contentArray count]-1;
    for(long i=[self.contentArray count]-11; i<[self.contentArray count]-1; i++ ){
        KDataModel* kTP1Data  = [self.contentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i];
        kT0Data.isLimitUp =  [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.close];
        
        
        
        if(kT0Data.isLimitUp){
            
            kTP1Data.ma5 = [[GSDataMgr shareInstance] getMAValue:5 array:self.contentArray t0Index:i-1];
            kTP1Data.ma10 = [[GSDataMgr shareInstance] getMAValue:10 array:self.contentArray t0Index:i-1];
            
            
            //filter raise much in shorttime
            if([self.param isMapRasingLimitAvgConditon:kTP1Data]){
                if(kT0Data.time >= 20160814){ // && kT0Data.time <= 20160816
                    KDataModel* kTLastData = [self.contentArray objectAtIndex:lastIndex];
                    CGFloat dvLast2kTP1DataMA5 = [[GSDataMgr shareInstance]getDVValueWithBaseValue:kTP1Data.ma5 destValue:kTLastData.close];
                    
                    //                    KDataModel* kT1Data = [self.contentArray objectAtIndex:i+1];
                    //                    KDataModel* kT2Data = [self.contentArray objectAtIndex:i+2];
                    
                    if (dvLast2kTP1DataMA5 < 5.f) {
                        SMLog(@"%@ kT0Data: %ld.  dvLast2kTP1DataMA5(%.2f)",[self.stkID substringFromIndex:2],kT0Data.time, dvLast2kTP1DataMA5);
                    }
                    
                    
                    //write to queryDB if need.
                    if(self.isWriteToQueryDB){
                        QueryResModel* model = [[QueryResModel alloc]init];
                        model.stkID = self.stkID;
                        model.time = kT0Data.time;
                        [[QueryDBManager defaultManager].qREsDBService addRecord:model];
                    }
                }
            }else{
                
            }
        }
    }
    
    
    
    [[LimitLogout shareInstance] SimpleLogOutResult:NO];
    
    
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
            }
                
//                long bIndex = 2;
//                kT0Data.TBuyData = [self.contentArray safeObjectAtIndex:i+bIndex];
//                buyValue = kT0Data.TBuyData.close;
            buyValue = kTP1Data.ma5 * self.param.buyPercent;
            long bIndex = [HelpService indexOfValueSmallThan:buyValue Array:self.contentArray start:i+1 stop:i+4 kT0data:kT0Data];
            if(bIndex == -1){ //not find
                continue;
            }
            
            kT0Data.TBuyData = [self.contentArray objectAtIndex:i+bIndex];
            
            
            sellValue = [self getSellValue:buyValue bIndexInArray:i+bIndex+1 kT0data:kT0Data];
            
            if(kT0Data.TSellData)
                [self dispatchResult2Array:kT0Data buyValue:buyValue sellValue:sellValue];
            
        }
        
    }
    
    
    [[LimitLogout shareInstance] SimpleLogOutResult:NO];
    
}


@end
