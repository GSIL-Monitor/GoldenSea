//
//  GSLogout.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseLogout.h"

#import "KDataModel.h"
#import "GSBaseAnalysisMgr.h"
#import "GSDataMgr.h"

#define Key_JustLogOut_All 1

@interface GSBaseLogout (){
//    long _lowIndexArray[20];
//    long _HighIndexArray[20];

}

@property (nonatomic, assign) long totalIndexCount;
//@property (nonatomic, strong) NSMutableArray* countArray;

@end

@implementation GSBaseLogout

SINGLETON_GENERATOR(GSBaseLogout, shareInstance);


-(id)init
{
    if(self = [super init]){
        self.paramArray = [NSMutableArray array];
    }
    
    return self;
}


-(void)SimpleLogOutResult:(BOOL)isJustLogFail
{
    [self _SimpleLogOutForAll:NO isJustLogFail:isJustLogFail];
}

-(void)_SimpleLogOutForAll:(BOOL)isForAll isJustLogFail:(BOOL)isJustLogFail
{
    if(Key_JustLogOut_All){
        if(!isForAll){
            return;
        }
    }
    
    
    NSArray* resultArray = [GSBaseAnalysisMgr shareInstance].resultArray;
    long totalCount = [GSBaseAnalysisMgr shareInstance].totalCount;
    if(isForAll){
        resultArray = [GSBaseAnalysisMgr shareInstance].param.allResultArray;
        totalCount = [GSBaseAnalysisMgr shareInstance].param.allTotalCount;
    }
    
//    GSBaseAnalysisMgr* analyMan = [GSBaseAnalysisMgr shareInstance];
    
    //calulate percent firstly
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
    for(long i=0; i<[resultArray count]; i++){
        tmpArray = [resultArray objectAtIndex:i];
        percent = [tmpArray count]*100.f/totalCount;
        
        if(!isForAll){
            SMLog(@"\nSTK:%@ %d-%d totalCount(%d): win(%.2f),loss(%.2f) --totalS2BDVValue(%2f) ",[GSBaseAnalysisMgr shareInstance].stkID,[GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate,totalCount,winPercent,lossPercent,[GSBaseAnalysisMgr shareInstance].totalS2BDVValue);
        }else{ //for all
            SMLog(@"index(%ld), percent(%.2f)  count(%d) ", i, percent,[tmpArray count]);
        }
        
        
        
        //logout detail.
        if(isForAll){
            for (KDataModel* kData in tmpArray) {
                SMLog(@"%@ TBuyData:%ld, TSellData:%ld, dvSelltoBuy:%.2f",kData.stkID, kData.TBuyData.time,kData.TSellData.time, kData.dvSelltoBuy);
            }
        }else{
            for (KDataModel* kData in tmpArray) {
                SMLog(@"%6ld  LowIndex:%ld, HighIndex:%ld,  TS2B:%.2f; TBuy(%6ld)-O:%.2f,H:%.2f,C:%.2f,L:%.2f;    TSell(%6ld)-O:%.2f,H:%.2f,C:%.2f,L:%.2f; ",kData.time,kData.lowValDayIndex,kData.highValDayIndex,kData.dvSelltoBuy,
                      kData.TBuyData.time,kData.TBuyData.dvT0.dvOpen,kData.TBuyData.dvT0.dvHigh,kData.TBuyData.dvT0.dvClose,kData.TBuyData.dvT0.dvLow,
                      kData.TSellData.time, kData.TSellData.dvT0.dvOpen,kData.TSellData.dvT0.dvHigh,kData.TSellData.dvT0.dvClose,kData.TSellData.dvT0.dvLow                      );
            }
        }
        
    }
    
    
    

    
    
}


-(void)analysisAndLogtoFile;
{
    [self reOrderParamArray];
    
//    GSAssert(NO, @"need implenet in child class");
}




-(void)logOutResult
{
    //logOut which loss item
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    
    
    GSBaseAnalysisMgr* analyMan = [GSBaseAnalysisMgr shareInstance];
    
    //calulate percent firstly
    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
    for(long i=0; i<[analyMan.resultArray count]; i++){
        tmpArray = [analyMan.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/analyMan.totalCount;
        
    }
    SMLog(@"\nSTK:%@ %d-%d totalCount(%d): win(%.2f),loss(%.2f) --totalS2BDVValue(%2f) ",analyMan.stkID,[GSDataMgr shareInstance].startDate,[GSDataMgr shareInstance].endDate,analyMan.totalCount,winPercent,lossPercent,analyMan.totalS2BDVValue);
    
    
//        return;
    
    for(long i=0; i<[analyMan.resultArray count]; i++){
        tmpArray = [analyMan.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/analyMan.totalCount;
        
        for (KDataModel* kData in tmpArray) {
            [self logResWithDV:kData];
//            [self logResWithValue:kData];
        }
    }
    
    
}



-(void)logResWithDV:(KDataModel*)kData
{
    SMLog(@"%6ld TP1-C:%.2f, T0-O:%.2f,H:%.2f,C:%.2f,L:%.2f;  TS2B:%.2f;  T1-O:%.2f,H:%.2f,C:%.2f,L:%.2f;  T2(O:%.2f,H:%.2f,C:%.2f,L:%.2f)",kData.time,
          kData.dvTP1.dvClose,
          kData.dvT0.dvOpen,kData.dvT0.dvHigh,kData.dvT0.dvClose,kData.dvT0.dvLow,
          kData.dvSelltoBuy,
          kData.dvT1.dvOpen,kData.dvT1.dvHigh,kData.dvT1.dvClose,kData.dvT1.dvLow,
          kData.dvT2.dvOpen,kData.dvT2.dvHigh,kData.dvT2.dvClose,kData.dvT2.dvLow);
    
}


//for debug: to check the programe is right.
-(void)logResWithValue:(KDataModel*)kData
{
    SMLog(@"%6ld TP1-Open:%.2f,High:%.2f,Low:%.2f,Close:%.2f,  T0-Open:%.2f,High:%.2f,Close:%.2f,Low:%.2f ;  T1-Open:%.2f,High:%.2f",kData.time,kData.TP1Data.open, kData.TP1Data.high,kData.TP1Data.low,kData.TP1Data.close,
          kData.open,kData.high, kData.close,kData.low,
          kData.T1Data.open,kData.T1Data.high);
}




#pragma mark - new
-(void)reOrderParamArray
{
    NSMutableArray* array = self.paramArray;
    
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:
//                             [NSDictionary dictionaryWithObjectsAndKeys:@"Obj0", [NSNumber numberWithInt:0], nil],
//                             [NSDictionary dictionaryWithObjectsAndKeys:@"Obj5", [NSNumber numberWithInt:5], nil],
//                             [NSDictionary dictionaryWithObjectsAndKeys:@"Obj2", [NSNumber numberWithInt:2], nil],
//                             [NSDictionary dictionaryWithObjectsAndKeys:@"Obj3", [NSNumber numberWithInt:3], nil],
//                             [NSDictionary dictionaryWithObjectsAndKeys:@"Obj1", [NSNumber numberWithInt:1], nil],
//                             [NSDictionary dictionaryWithObjectsAndKeys:@"Obj4", [NSNumber numberWithInt:4], nil], nil];
//    
//    //    NSArray *resultArray = [array sortedArrayUsingSelector:@selector(compare:)];
    
    NSArray *resultArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GSBaseParam* par1 = obj1;
        GSBaseParam* par2 = obj2;
        NSNumber *number1 = [NSNumber numberWithFloat: par1.allTotalS2BDVValue];
        NSNumber *number2 = [NSNumber numberWithFloat: par2.allTotalS2BDVValue];
        
//        NSNumber *number1 = [[obj1 allKeys] objectAtIndex:0];
//        NSNumber *number2 = [[obj2 allKeys] objectAtIndex:0];
        
        NSComparisonResult result = [number1 compare:number2];
        
//        return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
    }];
    
    
    self.paramArray = (NSMutableArray*)resultArray;
}

-(void)logWithParam:(GSBaseParam*)param;
{
    NSArray* resultArray = param.allResultArray;
    long totalCount = param.allTotalCount;
    
    //calulate percent firstly
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    CGFloat winPercent =0.f, holdPercent =0.f, lossPercent=0.f;
    for(long i=0; i<[resultArray count]; i++){
        tmpArray = [resultArray objectAtIndex:i];
        percent = [tmpArray count]*100.f/totalCount;
        
     
        SMLog(@"index(%ld), percent(%.2f)  count(%d) ", i, percent,[tmpArray count]);

        for (KDataModel* kData in tmpArray) {
            SMLog(@"%@ TBuyData:%ld(%d), TSellData:%ld(%d), dvSelltoBuy:%.2f",kData.stkID, kData.TBuyData.time,(kData.TBuyData.tIndex-kData.tIndex),kData.TSellData.time, (kData.TSellData.tIndex-kData.TBuyData.tIndex),kData.dvSelltoBuy);
        }
    }

}


#pragma mark - getter&setter
//-(NSMutableArray*)countArray{
//    if(!_countArray){
//        _countArray = [NSMutableArray array];
//        for(long i=0; i<9; i++){
//            NSNumber* count = [NSNumber numberWithInt:0];
//            [_countArray addObject:count];
//        }
//    }
//    
//    return _countArray;
//}

@end
