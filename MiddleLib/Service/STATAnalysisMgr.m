//
//  MonthStatAnalysisMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/11/8.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STATAnalysisMgr.h"

@implementation STKResult

-(id)init
{
    if(self = [super init]){
        self.avgDV = 0.f;
        self.eleArray = [NSMutableArray array];
    }
    
    return self;
}

@end


@implementation STATAnalysisMgr

-(id)init
{
    if(self = [super init]){
        self.statResultArray = [NSMutableArray array];
        self.dbgResultArray = [NSMutableArray array];
        self.badResultArray = [NSMutableArray array];
    }
    
    return self;
}

-(BOOL)isMapCondition:(long)i isQuery:(BOOL)isQuery
{
    return YES;
}


-(long)subtractVal:(long)evalMonth lastDBMonth:(long)lastDBMonth
{
    long subtractVal = 0;
    if(lastDBMonth >= evalMonth){
        subtractVal = lastDBMonth-evalMonth+1;
    }else{
        subtractVal = 12+lastDBMonth-evalMonth+1;
    }
    
    return subtractVal;
}

//query January
//使用此方法测试其它月份有效性

-(void)analysis
{
    NSArray* cxtArray = [self getCxtArray:self.period];
    if(! [self isValidDataPassedIn] || [cxtArray count]< 3 ) // || [cxtArray count]<20)
    {
        return;
    }
    
    long statDays = 0;
    STKResult* stkResult = [[STKResult alloc]init];
    CGFloat totolDV = 0.f, totalHighDV = 0.f;
    CGFloat fstClose=0.f, lastClose=0.f, lastHigh=0.f, the16fstClose=0.f, the16High=0.f;
    long winCount = 0;
    long evalMonth = 8;
    for(long i=1; i<(long)[cxtArray count]-[self subtractVal:evalMonth lastDBMonth:12]+1; i++){
        
        KDataModel* kT0Data = [cxtArray safeObjectAtIndex:i];
        if(kT0Data.close > lastHigh){
            lastHigh = kT0Data.close;
        }
        if(i == 1){
            fstClose = kT0Data.close;
        }else if(i == [cxtArray count]-[self subtractVal:evalMonth lastDBMonth:12]){
            lastClose = kT0Data.close;
        }
        
        [[GSDataMgr shareInstance]setCanlendarInfo:kT0Data];

        
        if(kT0Data.time > 20160101 && kT0Data.unitDbg.month<evalMonth){
            if(the16fstClose<0.1f){
                the16fstClose = kT0Data.close;
            }
            
            if(kT0Data.time > 20160201){
                if(the16High<kT0Data.high){
                    the16High = kT0Data.high;
                }
            }
        }
        
        if(kT0Data.unitDbg.month != evalMonth){
            continue;
        }
        
        KDataModel* kTP1Data  = [cxtArray objectAtIndex:(i-1)];

        
        if(kT0Data.time > 20160101){
            stkResult.the2016DV = kT0Data.close/kTP1Data.close;
            stkResult.the2016HighDV = kT0Data.high/kTP1Data.close;
            stkResult.the2016LowDV = kTP1Data.low/kTP1Data.close;
            continue;
        }
        

        kT0Data.dvDbg.dvT0.dvClose = kT0Data.close/kTP1Data.close;
        
        if(kT0Data.dvDbg.dvT0.dvClose > 1.5f){
            continue;
        }
        
        kT0Data.dvDbg.dvT0.dvHigh = kT0Data.high/kTP1Data.close;
        if(kT0Data.dvDbg.dvT0.dvClose > 1.005f){
            winCount++;
        }
        totolDV += kT0Data.dvDbg.dvT0.dvClose;
        totalHighDV += kT0Data.dvDbg.dvT0.dvHigh;
        if(kT0Data.dvDbg.dvT0.dvClose>0.1f){ //skip invlaid value such as 0.
            [stkResult.eleArray addObject:kT0Data];
        }
    }
    
//    if([self.stkID isEqualToString:@"SZ002514"]){
//        SMLog(@"");
//    }
    
    CGFloat lastDV = lastClose/fstClose;
    CGFloat lastHighDV = lastHigh/fstClose;
    CGFloat the16HighDV = the16High/the16fstClose;
    if(
       1
       && the16HighDV < 1.5f
       && lastHighDV < 4.5f
       && lastDV < 2.2f
       && [stkResult.eleArray count] > 2
       && ((CGFloat)winCount/[stkResult.eleArray count])>0.5f
       ){
        stkResult.avgDV = totolDV/[stkResult.eleArray count];
        if(stkResult.avgDV > 1.0f)
        {
            stkResult.stkID = self.stkID;
            stkResult.LastDV = lastDV;
            stkResult.avgHighDV = totalHighDV/[stkResult.eleArray count];
            [self.statResultArray addObject:stkResult];
        }else{ //dbg
            [self.dbgResultArray addObject:stkResult];
        }
    }
    else{
        [self.badResultArray addObject:stkResult];
    }
    
}

@end
