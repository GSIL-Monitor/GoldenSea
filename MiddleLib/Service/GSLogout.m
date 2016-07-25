//
//  GSLogout.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSLogout.h"

#import "KDataModel.h"
#import "GSAnalysisManager.h"
#import "GSDataInit.h"

@implementation GSLogout

SINGLETON_GENERATOR(GSLogout, shareManager);


-(void)logOutResultForStk:(NSString*)stkID
{
    //logOut which loss item
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    
    
    GSAnalysisManager* analyMan = [GSAnalysisManager shareManager];
    
    //calulate percent firstly
    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
    for(long i=0; i<[analyMan.resultArray count]; i++){
        tmpArray = [analyMan.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/analyMan.totalCount;
        
        if(i < analyMan.segIndex){
            winPercent += percent;
        }
        //        else if(i == 2){
        //            holdPercent += percent;
        //        }
        else{
            lossPercent += percent;
        }
    }
    
    if(analyMan.totalCount > 0){
        SMLog(@"STK:%@ - totalCount(%d): win(%.2f),loss(%.2f)",stkID,analyMan.totalCount,winPercent,lossPercent);
    }
    
    
    
    
}



-(void)SimpleLogOutResult:(BOOL)isJustLogFail
{
    //logOut which loss item
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    
    
    GSAnalysisManager* analyMan = [GSAnalysisManager shareManager];
    
    //calulate percent firstly
    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
    for(long i=0; i<[analyMan.resultArray count]; i++){
        tmpArray = [analyMan.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/analyMan.totalCount;
        
        if(i < analyMan.segIndex){
            winPercent += percent;
        }
        else{
            lossPercent += percent;
        }
    }
    SMLog(@"\nSTK:%@ %d-%d totalCount(%d): win(%.2f),loss(%.2f) --totalS2BDVValue(%2f) ",analyMan.stkID,[GSDataInit shareManager].startDate,[GSDataInit shareManager].endDate,analyMan.totalCount,winPercent,lossPercent,analyMan.totalS2BDVValue);

    for(long i=0; i<[analyMan.resultArray count]; i++){
        tmpArray = [analyMan.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/analyMan.totalCount;
        
        if(i < analyMan.segIndex){
            //            SMLog(@"win itme array :%ld, percent(%.2f)",i,percent);
        }
        else{
            if(isJustLogFail && [tmpArray count] ){
                for (KDataModel* kData in tmpArray) {
                    SMLog(@"%@   TS2B:%.2f; ",kData.time,kData.dvSelltoBuy);
                }
            }
        }
        
        if(!isJustLogFail){
            for (KDataModel* kData in tmpArray) {
                SMLog(@"%@   TS2B:%.2f; ",kData.time,kData.dvSelltoBuy);
            }
        }
        
    }
    
    
}


-(void)logOutResult
{
    //logOut which loss item
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    
    
    GSAnalysisManager* analyMan = [GSAnalysisManager shareManager];
    
    //calulate percent firstly
    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
    for(long i=0; i<[analyMan.resultArray count]; i++){
        tmpArray = [analyMan.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/analyMan.totalCount;
        
        if(i < analyMan.segIndex){
            winPercent += percent;
        }
        else{
            lossPercent += percent;
        }
    }
    SMLog(@"\nSTK:%@ %d-%d totalCount(%d): win(%.2f),loss(%.2f) --totalS2BDVValue(%2f) ",analyMan.stkID,[GSDataInit shareManager].startDate,[GSDataInit shareManager].endDate,analyMan.totalCount,winPercent,lossPercent,analyMan.totalS2BDVValue);
    
    
//        return;
    
    for(long i=0; i<[analyMan.resultArray count]; i++){
        tmpArray = [analyMan.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/analyMan.totalCount;
        
        if(i < analyMan.segIndex){
//            SMLog(@"win itme array :%ld, percent(%.2f)",i,percent);

        }
        else{
            if([tmpArray count]){
//                SMLog(@"loss itme array :%ld, percent(%.2f)",i,percent);
                for (KDataModel* kData in tmpArray) {
                    SMLog(@"%@   TS2B:%.2f; ",kData.time,kData.dvSelltoBuy);
                    //            [self logResWithDV:kData];
                    //            [self logResWithValue:kData];
                }
            }
        }
        
//        for (KDataModel* kData in tmpArray) {
//            [self logResWithDV:kData];
////            [self logResWithValue:kData];
//        }
    }
    
    
}

-(void)logResWithDV:(KDataModel*)kData
{
    SMLog(@"%@ TP1-C:%.2f, T0-O:%.2f,H:%.2f,C:%.2f,L:%.2f;  TS2B:%.2f;  T1-O:%.2f,H:%.2f,C:%.2f,L:%.2f;  T2(O:%.2f,H:%.2f,C:%.2f,L:%.2f)",kData.time,
          kData.dvTP1.dvClose,
          kData.dvT0.dvOpen,kData.dvT0.dvHigh,kData.dvT0.dvClose,kData.dvT0.dvLow,
          kData.dvSelltoBuy,
          kData.dvT1.dvOpen,kData.dvT1.dvHigh,kData.dvT1.dvClose,kData.dvT1.dvLow,
          kData.dvT2.dvOpen,kData.dvT2.dvHigh,kData.dvT2.dvClose,kData.dvT2.dvLow);
    
}


//for debug: to check the programe is right.
-(void)logResWithValue:(KDataModel*)kData
{
    SMLog(@"%@ TP1-Open:%.2f,High:%.2f,Low:%.2f,Close:%.2f,  T0-Open:%.2f,High:%.2f,Close:%.2f,Low:%.2f ;  T1-Open:%.2f,High:%.2f",kData.time,kData.TP1Data.open, kData.TP1Data.high,kData.TP1Data.low,kData.TP1Data.close,
          kData.open,kData.high, kData.close,kData.low,
          kData.T1Data.open,kData.T1Data.high);
}


//-(void)logResWithValue:(KDataModel*)kData
//{
//    SMLog(@"%@  TP1-High:%.2f,Low:%.2f,Close:%.2f,  T0-Open:%.2f,High:%.2f,Close:%.2f,Low:%.2f ;  T1-Open:%.2f,High:%.2f",kData.time, kData.TP1Data.high,kData.TP1Data.low,kData.TP1Data.close,
//          kData.dvT0.dvOpen,kData.dvT0.dvHigh,kData.dvT0.dvClose,kData.dvT0.dvLow,
//          kData.dvT1.dvOpen,kData.dvT1.dvHigh);
//}




@end
