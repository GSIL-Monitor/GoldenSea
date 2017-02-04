//
//  MainVC.m
//  GSGoldenSea
//
//  Created by frank weng on 16/11/7.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "MainVC.h"

#import "HYRequestManager.h"

#import "HYDatabaseHelper.h"
#import "HYDayDBManager.h"
#import "TKData.h"
#import "QueryDBManager.h"
#import "HYSTKDBManager.h"
#import "STKModel.h"

#import "STKManager.h"

#import "GSBaseAnalysisMgr.h"
#import "GSCondition.h"
#import "HYLog.h"
#import "GSDataMgr.h"
#import "NSTKLogout.h"
#import "STATLogout.h"

#import "LimitAnalysisMgr.h"
#import "AvgAnalysisMgr.h"
#import "TechAnalysisMgr.h"
#import "STATAnalysisMgr.h"
#import "NewStkAnalysisMgr.h"

#import "GSBaseResult.h"

#import "STKxlsReader.h"

@interface MainVC (){
    NSString* _filedir;

}

@end

@implementation MainVC

-(void)awakeFromNib{
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)initData{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    _filedir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/KDay",[paths stringByDeletingLastPathComponent]];
}

-(void)viewWillAppear{
    [super viewWillAppear];
    
}


#pragma mark - action
- (IBAction)onTest:(id)sender {
    
    NSLog(@"onTest");
    
    [self testForAllLimit:NO];
}


- (IBAction)onQuery:(id)sender {
    [self testForAllLimit:YES];

}


- (IBAction)onSaveData:(id)sender {   
    //    [GSDataMgr shareInstance].startDate = 20140125;
    //    [GSDataMgr shareInstance].startDate = 20151001;
//    [GSDataMgr shareInstance].startDate = 20160225;
    
    [GSObjMgr shareInstance].mgr = [[TechAnalysisMgr alloc]init];
//    [GSDataMgr shareInstance].isJustWriteNSTK = YES;
    
//    [GSObjMgr shareInstance].mgr.stkRangeArray = @[@"SH600000",@"SH000001"];
//    [GSObjMgr shareInstance].mgr.stkRangeArray = @[@"SZ002005"]; //SH600108

    
//    [[GSDataMgr shareInstance] writeDataToDB:_filedir EndDate:20170119];
    [[GSDataMgr shareInstance] writeDataToDB:_filedir EndDate:20170203];

}

- (IBAction)onNSTK:(id)sender {
    [self testForNewSTK];
}

- (IBAction)onSTAT:(id)sender {
    [self testForStat];
}


#pragma mark - internal
-(void)configureMgr
{
    [GSDataMgr shareInstance].startDate = 20160201;
    
//        [GSObjMgr shareInstance].mgr.stkRangeArray = @[@"SH603199"];
    //    [GSObjMgr shareInstance].mgr.stkRangeArray = @[@"SH600098"]; //,@"SH600418",@"SZ000592"];
//        [GSObjMgr shareInstance].mgr.stkRangeArray = @[@"SZ300505"]; //SH600108
    
        [GSDataMgr shareInstance].marketType = marketType_ShenZhenChuanYeBan; //
    //        [GSDataMgr shareInstance].marketType = marketType_ShenZhenMainAndZhenXiaoBan;
    [GSDataMgr shareInstance].marketType = marketType_ShangHai;
//        [GSDataMgr shareInstance].marketType = marketType_All;
    
    GSBaseResult* baseReslut = [[GSBaseResult alloc]init];
    [GSObjMgr shareInstance].mgr.reslut = baseReslut;
    
}



-(void)testForStat
{
    [GSObjMgr shareInstance].mgr = [[STATAnalysisMgr alloc]init];
    [self configureMgr];
//    NSMutableArray* rangeArray = [NSMutableArray array];
//    NSArray* stkArray = [[HYSTKDBManager defaultManager].allSTK getRecordsWithIndustry:@"农"];
//    for(long i=0; i<[stkArray count]; i++){
//        STKModel* stk = [stkArray safeObjectAtIndex:i];
//        [rangeArray addObject:stk.stkID];
//    }
//    [GSObjMgr shareInstance].mgr.stkRangeArray = rangeArray;
    [GSObjMgr shareInstance].mgr.period = Period_month;
    [GSObjMgr shareInstance].log = [[STATLogout alloc]init];
    
    GSBaseParam* param = [[GSBaseParam alloc]init];
    param.destDVValue = 10.f;
    param.durationAfterBuy = 1;
    [GSObjMgr shareInstance].mgr.param = param;
    
    
    [[GSObjMgr shareInstance].mgr analysisAllInDir:_filedir];
    [ [GSObjMgr shareInstance].log analysisAndLogtoFile];
}


-(void)testForNewSTK
{
    [GSObjMgr shareInstance].mgr = [[NewStkAnalysisMgr alloc]init];
    GSBaseResult* baseReslut = [[GSBaseResult alloc]init];
    [GSObjMgr shareInstance].mgr.reslut = baseReslut;
    [GSObjMgr shareInstance].log = [[NSTKLogout alloc]init];
    
    GSBaseParam* param = [[GSBaseParam alloc]init];
    param.destDVValue = 2.f;
    param.durationAfterBuy = 1;
    [GSObjMgr shareInstance].mgr.param = param;
    
    
    param = [[GSBaseParam alloc]init];
    NewStkAnalysisMgr* mgr  = (NewStkAnalysisMgr*)[GSObjMgr shareInstance].mgr;
    mgr.NSTKparam = param;
    
    [[GSObjMgr shareInstance].mgr analysisAllInDir:_filedir];
    [ [GSObjMgr shareInstance].log analysisAndLogtoFile];
}


-(void)testForTech
{
    
    //    [GSDataMgr shareInstance].startDate = 20160125;
    
    [GSObjMgr shareInstance].mgr = [[TechAnalysisMgr alloc]init];
    [self configureMgr];
    [GSObjMgr shareInstance].mgr.period = Period_month; // Period_day;
    [GSObjMgr shareInstance].log = [[GSBaseLogout alloc]init];
    
    
//    //do query;
//    //#if 0
//    //    [[GSObjMgr shareInstance].mgr queryAllWithFile:_filedir];
//    //
//    //
//    //    for(long i=1; i<=3; i++){
//    //        GSBaseParam* param = [[GSBaseParam alloc]init];
//    //        param.destDVValue = 12.5f;
//    //        param.durationAfterBuy = i;
//    //        [GSObjMgr shareInstance].mgr.param = param;
//    //
//    //        [[GSObjMgr shareInstance].mgr analysisQuerySTKArray:_filedir];
//    //    }
//    //
//    //    [ [GSObjMgr shareInstance].log analysisAndLogSummry];
//    //    return;
//    //#endif
//    
//    
//    return;
    
    for(long i=1; i<=1; i++){
        GSBaseParam* param = [[GSBaseParam alloc]init];
        param.destDVValue = 25;
        param.durationAfterBuy = 1; //i
        [GSObjMgr shareInstance].mgr.param = param;
        
        [[GSObjMgr shareInstance].mgr analysisAllInDir:_filedir];
    }
    
    [ [GSObjMgr shareInstance].log analysisAndLogtoFile];
}

-(void)testForAvg
{
    [GSObjMgr shareInstance].mgr = [[AvgAnalysisMgr alloc]init];
    [self configureMgr];
    [GSObjMgr shareInstance].log = [[GSBaseLogout alloc]init];
    
    GSBaseParam* param = [[GSBaseParam alloc]init];
    param.destDVValue = 2.f;
    param.durationAfterBuy = 3;
    [GSObjMgr shareInstance].mgr.param = param;
    
    
    [[GSObjMgr shareInstance].mgr analysisAllInDir:_filedir];
    [ [GSObjMgr shareInstance].log analysisAndLogtoFile];
}

-(void)testForAllLimit:(BOOL)isQuery
{
    
    [GSObjMgr shareInstance].mgr = [[LimitAnalysisMgr alloc]init];
    [self configureMgr];
    [GSObjMgr shareInstance].log = [[LimitLogout alloc]init];
    
    
    RaisingLimitParam* param = [[RaisingLimitParam alloc]init];
    //tmp best.
    param.daysAfterLastLimit = 30;
    param.buyPercent = 1.03;
    param.destDVValue = 3.f;
    param.durationAfterBuy = 2;
    param.buyStartIndex = 1;
    param.buyEndIndex = 3; //param.buyStartIndex;
    [GSObjMgr shareInstance].mgr.param = param;
    
    if(isQuery){ //query
        [GSDataMgr shareInstance].marketType = marketType_All;
        [[GSObjMgr shareInstance].mgr queryAllWithFile:_filedir];
        
    }else{ //analysis
        [[GSObjMgr shareInstance].mgr analysisAllInDir:_filedir];
        [ [GSObjMgr shareInstance].log analysisAndLogtoFile];
    }
    
    return;
    
    //    [[[GSObjMgr shareInstance].mgr]queryAllAndSaveToDBWithFile:_filedir];
    ////    [[[GSObjMgr shareInstance].mgr]queryAllWithDB:_filedir];
    //    return;
    
    
    
    //    param.buyPercent = 0.98;
    //    param.destDVValue = 6.f;
    
    for(long buyIndex = 1; buyIndex<=4; buyIndex++)
    {
        param.buyStartIndex = buyIndex;
        param.buyEndIndex = param.buyStartIndex;
        
        [GSObjMgr shareInstance].mgr.param = param;
        [[GSObjMgr shareInstance].mgr analysisAllInDir:_filedir];
    }
    
    [ [GSObjMgr shareInstance].log analysisAndLogSummry];
    
    return;
    
    
    long percentStart = 0, percentEnd = 0;
    long destDVStart = 4, destDVEnd = 6;
    
#if 1
    //短期机会
    percentStart = 8, percentEnd = 17;
#else
    //中期机会
#endif
    
    for(long pIndex = percentStart; pIndex <=percentEnd;pIndex++)
    {
        param.buyPercent  = 0.9+(pIndex*0.01);
        
        for(long dvIndex=destDVStart; dvIndex<=destDVEnd; dvIndex++)
        {
            param.destDVValue = 1.f*dvIndex;
            [GSObjMgr shareInstance].mgr.param = param;
            [[GSObjMgr shareInstance].mgr analysisAllInDir:_filedir];
        }
    }
    
    [[GSObjMgr shareInstance].log analysisAndLogtoFile];
    
}



@end
