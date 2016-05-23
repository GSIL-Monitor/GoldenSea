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

@implementation GSLogout

SINGLETON_GENERATOR(GSLogout, shareManager);



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
        
        if(i < 2){
            winPercent += percent;
        }else if(i == 2){
            holdPercent += percent;
        }else{
            lossPercent += percent;
        }
    }
    SMLog(@"totalCount(%d): win(%.2f),hold(%.2f),loss(%.2f)",analyMan.totalCount,winPercent,holdPercent,lossPercent);
    
    
    //    return;
    
    for(long i=0; i<[analyMan.resultArray count]; i++){
        tmpArray = [analyMan.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/analyMan.totalCount;
        
        if(i < 2){
            SMLog(@"win itme array :%ld, percent(%.2f)",i,percent);
        }else if(i == 2){
            SMLog(@"hold itme array :%ld, percent(%.2f)",i,percent);
        }else{
            SMLog(@"--loss itme array :%ld, percent(%.2f)",i,percent);
        }
        
        for (KDataModel* kData in tmpArray) {
                        [self logResWithDV:kData];
//            [self logResWithValue:kData];
        }
    }
    
    
}

-(void)logResWithDV:(KDataModel*)kData
{
    SMLog(@"%@  TP1-High:%.2f,Low:%.2f,Close:%.2f,  T0-Open:%.2f,High:%.2f,Close:%.2f,Low:%.2f,openVSlow:%.2f ;  T1-Open:%.2f,High:%.2f",kData.time, kData.dvTP1.dvHigh,kData.dvTP1.dvLow,kData.dvTP1.dvClose,
          kData.dvT0.dvOpen,kData.dvT0.dvHigh,kData.dvT0.dvClose,kData.dvT0.dvLow,(kData.dvT0.dvLow-kData.dvT0.dvOpen),
          kData.dvT1.dvOpen,kData.dvT1.dvHigh);
}

-(void)logResWithValue:(KDataModel*)kData
{
    SMLog(@"%@  TP1-Open:%.2f,High:%.2f,Low:%.2f,Close:%.2f,  T0-Open:%.2f,High:%.2f,Close:%.2f,Low:%.2f ;  T1-Open:%.2f,High:%.2f",kData.time,kData.TP1Data.open, kData.TP1Data.high,kData.TP1Data.low,kData.TP1Data.close,
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