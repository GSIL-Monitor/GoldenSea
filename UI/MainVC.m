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

#import "LimitAnalysisMgr.h"
#import "AvgAnalysisMgr.h"
#import "TechAnalysisMgr.h"
#import "MonthStatAnalysisMgr.h"
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
    
    [self testForMonthStat];
}


- (IBAction)onQuery:(id)sender {
}


- (IBAction)onSaveData:(id)sender {   
    //    [GSDataMgr shareInstance].startDate = 20140125;
    //    [GSDataMgr shareInstance].startDate = 20151001;
//    [GSDataMgr shareInstance].startDate = 20160225;
    
    [GSObjMgr shareInstance].mgr = [[TechAnalysisMgr alloc]init];
    [GSDataMgr shareInstance].isJustWriteNSTK = YES;
    
    [[GSDataMgr shareInstance] writeDataToDB:_filedir EndDate:20161214];
}


#pragma mark - internal
-(void)configureMgr
{
    [GSDataMgr shareInstance].startDate = 20160225;
    
    //    [GSObjMgr shareInstance].mgr.stkRangeArray = @[@"SZ000592"];
    //    [GSObjMgr shareInstance].mgr.stkRangeArray = @[@"SH600098"]; //,@"SH600418",@"SZ000592"];
    //    [GSObjMgr shareInstance].mgr.stkRangeArray = @[@"SZ002770"]; //SH600108
    
    //    [GSDataMgr shareInstance].marketType = marketType_ShenZhenChuanYeBan; //
    //        [GSDataMgr shareInstance].marketType = marketType_ShenZhenMainAndZhenXiaoBan;
    [GSDataMgr shareInstance].marketType = marketType_ShangHai;
    //    [GSDataMgr shareInstance].marketType = marketType_All;
    
    GSBaseResult* baseReslut = [[GSBaseResult alloc]init];
    [GSObjMgr shareInstance].mgr.reslut = baseReslut;
    
}

-(void)testForNewSTK
{
    [GSObjMgr shareInstance].mgr = [[NewStkAnalysisMgr alloc]init];
    [self configureMgr];
    [GSObjMgr shareInstance].log = [[GSBaseLogout alloc]init];
    
    GSBaseParam* param = [[GSBaseParam alloc]init];
    param.destDVValue = 2.f;
    param.durationAfterBuy = 3;
    [GSObjMgr shareInstance].mgr.param = param;
    
    
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

-(void)testForAllLimit
{
    
    [GSObjMgr shareInstance].mgr = [[LimitAnalysisMgr alloc]init];
    [self configureMgr];
    [GSObjMgr shareInstance].log = [[LimitLogout alloc]init];
    
    
    RaisingLimitParam* param = [[RaisingLimitParam alloc]init];
    //tmp best.
    param.daysAfterLastLimit = 15; //30;
    param.buyPercent = 1.03;
    param.destDVValue = 3.f;
    param.durationAfterBuy = 3;
    param.buyStartIndex = 1;
    param.buyEndIndex = 4; //param.buyStartIndex;
    [GSObjMgr shareInstance].mgr.param = param;
    
    [[GSObjMgr shareInstance].mgr analysisAllInDir:_filedir];
    [ [GSObjMgr shareInstance].log analysisAndLogtoFile];
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


-(void)testForMonthStat
{
    [GSObjMgr shareInstance].mgr = [[MonthStatAnalysisMgr alloc]init];
    [self configureMgr];
    NSMutableArray* rangeArray = [NSMutableArray array];
    NSArray* stkArray = [[HYSTKDBManager defaultManager].allSTK getRecordsWithIndustry:@"农"];
    for(long i=0; i<[stkArray count]; i++){
        STKModel* stk = [stkArray safeObjectAtIndex:i];
        [rangeArray addObject:stk.stkID];
    }
    [GSObjMgr shareInstance].mgr.stkRangeArray = rangeArray;
    [GSObjMgr shareInstance].mgr.period = Period_month;
    [GSObjMgr shareInstance].log = [[GSBaseLogout alloc]init];
    
    GSBaseParam* param = [[GSBaseParam alloc]init];
    param.destDVValue = 10.f;
    param.durationAfterBuy = 1;
    [GSObjMgr shareInstance].mgr.param = param;
    
    
    [[GSObjMgr shareInstance].mgr analysisAllInDir:_filedir];
    [ [GSObjMgr shareInstance].log analysisAndLogtoFile];
}


//
//-(void)setOpenValue
//{
//    //    [GSCondition shareInstance].t0Cond = T0Condition_Down;
//    
//    //    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
//    //    tp2con.close_max = 1.f;
//    //    tp2con.close_min = -1.2f;
//    //    [GSObjMgr shareInstance].mgr.tp2dayCond = tp2con;
//    //
//    
//    //    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    //    tp1con.close_min = -0.5f;
//    //    tp1con.close_max = 2.f;
//    //    [GSObjMgr shareInstance].mgr.tp1dayCond = tp1con;
//    
//    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    t0con.open_min = 1.0f;
//    t0con.open_max = 2.0f;
//    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
//    
//    //    [GSCondition shareInstance].shapeCond= ShapeCondition_UpShadow;
//    
//    
//    OneDayCondition* t1con = [[OneDayCondition alloc]init];
//    //    t1con.open_max = 0.4f;
//    //    t1con.open_min = -0.4f;
//    //    t1con.high_max = 2.5f;
//    //    t1con.high_min = 1.2f;
//    [GSObjMgr shareInstance].mgr.t1dayCond = t1con;
//    
//    
//    //    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    //    t2con.open_max = 1.f;
//    //    t2con.open_min = 0.3f;
//    //
//    //
//    //    [GSObjMgr shareInstance].mgr.tp2dayCond = t2con;
//}
//
//
//-(void)setNormalToday
//{
//    //    [GSCondition shareInstance].t0Cond = T0Condition_Down;
//    
//    //    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
//    //    tp2con.close_max = 1.f;
//    //    tp2con.close_min = -1.2f;
//    //    [GSObjMgr shareInstance].mgr.tp2dayCond = tp2con;
//    //
//    
//    //    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    //    tp1con.close_min = -4.5f;
//    //    tp1con.close_max = -3.f;
//    //    [GSObjMgr shareInstance].mgr.tp1dayCond = tp1con;
//    //
//    //    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    //    t0con.close_min = 0.5f;
//    //    t0con.close_max = 2.0f;
//    //    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
//    
//    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
//    tp2con.close_min = 1.f;
//    tp2con.close_max = 3.f;
//    [GSObjMgr shareInstance].mgr.tp2dayCond = tp2con;
//    
//    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    tp1con.close_min = 0.5f;
//    tp1con.close_max = 2.2f;
//    [GSObjMgr shareInstance].mgr.tp1dayCond = tp1con;
//    
//    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    t0con.close_min = -1.f;
//    t0con.close_max = 0.3f;
//    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
//    
//    OneDayCondition* t1con = [[OneDayCondition alloc]init];
//    t1con.close_min = -1.f;
//    t1con.close_max = 0.3f;
//    [GSObjMgr shareInstance].mgr.t1dayCond = t1con;
//    
//    
//    //    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    //    t2con.open_max = 1.5f;
//    //    t2con.open_min = 0.5f;
//    //    [GSObjMgr shareInstance].mgr.t2 = t2con;
//}
//
//
//
//-(void)setUpShadow
//{
//    //    [GSCondition shareInstance].t0Cond = T0Condition_Down;
//    
//    //    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
//    //    tp2con.close_max = 1.f;
//    //    tp2con.close_min = -1.2f;
//    //    [GSObjMgr shareInstance].mgr.tp2dayCond = tp2con;
//    //
//    
//    //    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    //    tp1con.close_min = -4.5f;
//    //    tp1con.close_max = -3.f;
//    //    [GSObjMgr shareInstance].mgr.tp1dayCond = tp1con;
//    
//    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    t0con.close_min = 0.5f;
//    t0con.close_max = 2.0f;
//    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
//    
//    [GSCondition shareInstance].shapeCond= ShapeCondition_UpShadow;
//    
//    
//    OneDayCondition* t1con = [[OneDayCondition alloc]init];
//    //    t1con.open_max = 0.4f;
//    //    t1con.open_min = -0.4f;
//    //    t1con.high_max = 2.5f;
//    //    t1con.high_min = 1.2f;
//    [GSObjMgr shareInstance].mgr.t1dayCond = t1con;
//    
//    
//    //    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    //    t2con.open_max = 1.f;
//    //    t2con.open_min = 0.3f;
//    //
//    //
//    //    [GSObjMgr shareInstance].mgr.tp2dayCond = t2con;
//}
//
//
//
//
//-(void)setNormalDown
//{
//    [GSCondition shareInstance].t0Cond = T0Condition_Down;
//    
//    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    t0con.close_max = -2.0f;
//    t0con.close_min = -3.5f;
//    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
//    
//    OneDayCondition* t1con = [[OneDayCondition alloc]init];
//    t1con.open_max = 1.f;
//    t1con.open_min = -1.f;
//    t1con.high_max = 2.5f;
//    t1con.high_min = 1.2f;
//    //    t1con.close_max = -0.6f;
//    //    t1con.close_min = -1.8f;
//    [GSObjMgr shareInstance].mgr.t1dayCond = t1con;
//    
//    
//    //    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    //    t2con.open_max = 1.f;
//    //    t2con.open_min = 0.3f;
//    //
//    //
//    //    [GSObjMgr shareInstance].mgr.tp2dayCond = t2con;
//}
//
//
//-(void)setNormalUp
//{
//    [GSCondition shareInstance].t0Cond = T0Condition_Up;
//    
//    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    t0con.close_max = 2.5f;
//    t0con.close_min = 1.3f;
//    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
//    
//    //    OneDayCondition* t1con = [[OneDayCondition alloc]init];
//    ////    t1con.open_max = -0.1f;
//    ////    t1con.open_min = -1.f;
//    ////    t1con.open_max = 1.1f;
//    ////    t1con.open_min = 0.f;
//    //    t1con.close_max = -0.6f;
//    //    t1con.close_min = -1.8f;
//    //    [GSObjMgr shareInstance].mgr.t1dayCond = t1con;
//    
//    
//    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    t2con.open_max = 1.f;
//    t2con.open_min = 0.3f;
//    
//    
//    [GSObjMgr shareInstance].mgr.tp2dayCond = t2con;
//}
//
//
//-(OneDayCondition*)setCodintionCase0Toady
//{
//    KDataModel* kData0 = [[KDataModel alloc]init];
//    kData0.open = 11.54;
//    kData0.high = 11.95;
//    kData0.low = 11.32;
//    kData0.close = 11.75;
//    
//    
//    KDataModel* kData1 = [[KDataModel alloc]init];
//    //    kData1.open = 11.60;
//    //    kData1.high = 11.66;
//    kData1.low = 11.23;
//    kData1.close = 11.57;
//    KDataModel* kData2 = [[KDataModel alloc]init];
//    kData2.close = 11.75;
//    
//    
//    //    OneDayCondition* theCond = [[OneDayCondition alloc]initWithKData:kData0 baseCloseValue:11.47f];
//    OneDayCondition* theCond = [[OneDayCondition alloc]initWithKData:kData1 baseCloseValue:11.75f];
//    //    theCond.dvRange = 0.9;
//    
//    [GSObjMgr shareInstance].mgr.tp1dayCond = theCond;
//    [theCond logOutCondition];
//    
//    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    //    t0con.open_max = -0.2f;
//    //    t0con.open_min = -2.f;
//    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
//    
//    return theCond;
//}



@end
