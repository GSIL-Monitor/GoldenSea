//
//  AppDelegate.m
//  GSGoldenSea
//
//  Created by frank weng on 16/2/26.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "AppDelegate.h"

#import "HYRequestManager.h"

#import "HYDatabaseHelper.h"
#import "HYDBManager.h"
#import "KDataDBService.h"
#import "QueryDBManager.h"

#import "STKManager.h"

#import "GSAnalysisManager.h"
#import "GSCondition.h"
#import "HYLog.h"
#import "GSDataInit.h"

@interface AppDelegate (){
    
    NSString* _filedir;
    NSString* _dbdir;
    NSString* _queryDbdir; //for query result.
    NSString* _stkID;
    
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    //get data.
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyyMMdd HH.mm.ss"];
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    NSString * strNowDateTime = [df stringFromDate:currentDate];
    NSString *strNowDate= [strNowDateTime substringToIndex:8];
    
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    _filedir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/KDay",[paths stringByDeletingLastPathComponent]];
    _dbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSStkDB160817.db",[paths stringByDeletingLastPathComponent]];
    [[HYDBManager defaultManager]setupDB:_dbdir isReset:NO];
    
    
//    [[GSDataInit shareInstance]writeDataToDB:_filedir];
//    return;

    
//    _queryDbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSQuery%@.db",[paths stringByDeletingLastPathComponent],strNowDate];
//    [[QueryDBManager defaultManager]setupDB:_queryDbdir isReset:NO];

    

    
//    [[HYLog shareInstance] enableLog];
    
    //    [GSDataInit shareInstance].startDate = 20110101;
    //    [GSDataInit shareInstance].endDate = 20120101;
    //
    //    [GSDataInit shareInstance].startDate = 20120101;
    //    [GSDataInit shareInstance].endDate = 20130101;
    //
    //    [GSDataInit shareInstance].startDate = 20140101;
    //    [GSDataInit shareInstance].endDate = 20150101;
    //
    //    [GSDataInit shareInstance].startDate = 20150101;
    //    [GSDataInit shareInstance].endDate = 20160101;
    //
    //    [GSDataInit shareInstance].startDate = 20160101;
    //    [GSDataInit shareInstance].endDate = 20170101;
    
    
    //regsiter net
    //    [[HYRequestManager sharedInstance]initService];
    //    [[STKManager shareInstance]testGetFriPostsRequest];
    //    [[STKManager shareInstance]test];
    
    [self doInit];
    
    //分析最近周期（比如3个月）第一个涨停
    
}

-(void)doInit{

    _stkID = @"SH600418"; //jhqc
    
    //    _stkID = @"SH601002";
    //    _stkID = @"SH600126"; //hggf
//    _stkID = @"SZ002430"; //hygf
    _stkID = @"SZ000912"; //泸天化
//    _stkID = @"SZ300460";
    
//    [GSAnalysisManager shareInstance].stkRangeArray = @[@"SH600000"];
//    [GSAnalysisManager shareInstance].stkRangeArray = [[GSDataInit shareInstance]getStkRangeFromQueryDB];


//    [[GSAnalysisManager shareInstance]queryAllInDir:_filedir];
//    return;
    
    
    [[HYLog shareInstance]enableLog];

    [self testForAll];
}



-(void)testForAll
{
   
    [RaisingLimitParam shareInstance].durationAfterBuy = 3;
    [RaisingLimitParam shareInstance].buyPercent = 0.95;
    [RaisingLimitParam shareInstance].daysAfterLastLimit = 30;
    
//    [GSDataInit shareInstance].marketType = marketType_ShenZhenChuanYeBan; //
//    [GSDataInit shareInstance].marketType = marketType_ShenZhenMainAndZhenXiaoBan;
//    [GSDataInit shareInstance].marketType = marketType_ShangHai;
    [GSDataInit shareInstance].marketType = marketType_All;

    [GSDataInit shareInstance].startDate = 20160125;
//    [GSDataInit shareInstance].startDate = 20160725;
    
    [GSAnalysisManager shareInstance].destDVValue = 5.f;
    [[GSAnalysisManager shareInstance]analysisAllInDir:_filedir];
    return;

//    [GSAnalysisManager shareInstance].destDVValue = 10.f;
//    [[GSAnalysisManager shareInstance]analysisAllInDir:_filedir];

#if 0
    //短期机会
//    for(long i=3; i<15; i++)
//    for(long j = 3;j<8;j++)
    for(long j = 9;j<12;j++)
    {
        [RaisingLimitParam shareInstance].buyPercent  = 0.9+(j*0.01);
        SMLog(@"\n----[RaisingLimitParam shareInstance].buyPercent: %.2f",[RaisingLimitParam shareInstance].buyPercent);
        
//        for(long i=3; i<12; i++)
        for(long i=3; i<6; i++)
        {
            [GSAnalysisManager shareInstance].destDVValue = 1.f*i;
            [[GSAnalysisManager shareInstance]analysisAllInDir:_filedir];
        }
    }
#else
    //中期机会
    for(long k=2; k<5; k++){
        [RaisingLimitParam shareInstance].daysAfterLastLimit = k;
        for(long j = 9;j<13;j++)
        {
            [RaisingLimitParam shareInstance].buyPercent  = 0.9+(j*0.02);
            SMLog(@"\n----daysAfterLastLimit:%d. buyPercent: %.2f",[RaisingLimitParam shareInstance].daysAfterLastLimit,[RaisingLimitParam shareInstance].buyPercent);
            
            //        for(long i=3; i<12; i++)
            for(long i=2; i<=5; i++)
            {
                [GSAnalysisManager shareInstance].destDVValue = 1.5f*i;
                [[GSAnalysisManager shareInstance]analysisAllInDir:_filedir];
            }
        }
    }
#endif
    
}



-(void)setOpenValue
{
    //    [GSCondition shareInstance].t0Cond = T0Condition_Down;
    
    //    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
    //    tp2con.close_max = 1.f;
    //    tp2con.close_min = -1.2f;
    //    [GSAnalysisManager shareInstance].tp2dayCond = tp2con;
    //
    
//    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    tp1con.close_min = -0.5f;
//    tp1con.close_max = 2.f;
//    [GSAnalysisManager shareInstance].tp1dayCond = tp1con;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.open_min = 1.0f;
    t0con.open_max = 2.0f;
    [GSAnalysisManager shareInstance].t0dayCond = t0con;
    
//    [GSCondition shareInstance].shapeCond= ShapeCondition_UpShadow;
    
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    //    t1con.open_max = 0.4f;
    //    t1con.open_min = -0.4f;
    //    t1con.high_max = 2.5f;
    //    t1con.high_min = 1.2f;
    [GSAnalysisManager shareInstance].t1dayCond = t1con;
    
    
    //    OneDayCondition* t2con = [[OneDayCondition alloc]init];
    //    t2con.open_max = 1.f;
    //    t2con.open_min = 0.3f;
    //
    //
    //    [GSAnalysisManager shareInstance].tp2dayCond = t2con;
}


-(void)setNormalToday
{
//    [GSCondition shareInstance].t0Cond = T0Condition_Down;
    
//    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
//    tp2con.close_max = 1.f;
//    tp2con.close_min = -1.2f;
//    [GSAnalysisManager shareInstance].tp2dayCond = tp2con;
//
    
//    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    tp1con.close_min = -4.5f;
//    tp1con.close_max = -3.f;
//    [GSAnalysisManager shareInstance].tp1dayCond = tp1con;
//    
//    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    t0con.close_min = 0.5f;
//    t0con.close_max = 2.0f;
//    [GSAnalysisManager shareInstance].t0dayCond = t0con;
    
    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
    tp2con.close_min = 1.f;
    tp2con.close_max = 3.f;
    [GSAnalysisManager shareInstance].tp2dayCond = tp2con;
    
    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
    tp1con.close_min = 0.5f;
    tp1con.close_max = 2.2f;
    [GSAnalysisManager shareInstance].tp1dayCond = tp1con;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_min = -1.f;
    t0con.close_max = 0.3f;
    [GSAnalysisManager shareInstance].t0dayCond = t0con;
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    t1con.close_min = -1.f;
    t1con.close_max = 0.3f;
    [GSAnalysisManager shareInstance].t1dayCond = t1con;
    
    
//    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    t2con.open_max = 1.5f;
//    t2con.open_min = 0.5f;
//    [GSAnalysisManager shareInstance].t2 = t2con;
}



-(void)setUpShadow
{
    //    [GSCondition shareInstance].t0Cond = T0Condition_Down;
    
    //    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
    //    tp2con.close_max = 1.f;
    //    tp2con.close_min = -1.2f;
    //    [GSAnalysisManager shareInstance].tp2dayCond = tp2con;
    //
    
//    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    tp1con.close_min = -4.5f;
//    tp1con.close_max = -3.f;
//    [GSAnalysisManager shareInstance].tp1dayCond = tp1con;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_min = 0.5f;
    t0con.close_max = 2.0f;
    [GSAnalysisManager shareInstance].t0dayCond = t0con;

    [GSCondition shareInstance].shapeCond= ShapeCondition_UpShadow;
 
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    //    t1con.open_max = 0.4f;
    //    t1con.open_min = -0.4f;
    //    t1con.high_max = 2.5f;
    //    t1con.high_min = 1.2f;
    [GSAnalysisManager shareInstance].t1dayCond = t1con;
    
    
    //    OneDayCondition* t2con = [[OneDayCondition alloc]init];
    //    t2con.open_max = 1.f;
    //    t2con.open_min = 0.3f;
    //
    //
    //    [GSAnalysisManager shareInstance].tp2dayCond = t2con;
}




-(void)setNormalDown
{
    [GSCondition shareInstance].t0Cond = T0Condition_Down;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_max = -2.0f;
    t0con.close_min = -3.5f;
    [GSAnalysisManager shareInstance].t0dayCond = t0con;
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    t1con.open_max = 1.f;
    t1con.open_min = -1.f;
    t1con.high_max = 2.5f;
    t1con.high_min = 1.2f;
//    t1con.close_max = -0.6f;
//    t1con.close_min = -1.8f;
    [GSAnalysisManager shareInstance].t1dayCond = t1con;
    
    
//    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    t2con.open_max = 1.f;
//    t2con.open_min = 0.3f;
//    
//    
//    [GSAnalysisManager shareInstance].tp2dayCond = t2con;
}


-(void)setNormalUp
{
    [GSCondition shareInstance].t0Cond = T0Condition_Up;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_max = 2.5f;
    t0con.close_min = 1.3f;
    [GSAnalysisManager shareInstance].t0dayCond = t0con;
    
//    OneDayCondition* t1con = [[OneDayCondition alloc]init];
////    t1con.open_max = -0.1f;
////    t1con.open_min = -1.f;
////    t1con.open_max = 1.1f;
////    t1con.open_min = 0.f;
//    t1con.close_max = -0.6f;
//    t1con.close_min = -1.8f;
//    [GSAnalysisManager shareInstance].t1dayCond = t1con;
    
    
    OneDayCondition* t2con = [[OneDayCondition alloc]init];
        t2con.open_max = 1.f;
        t2con.open_min = 0.3f;


    [GSAnalysisManager shareInstance].tp2dayCond = t2con;
}


-(OneDayCondition*)setCodintionCase0Toady
{
    KDataModel* kData0 = [[KDataModel alloc]init];
    kData0.open = 11.54;
    kData0.high = 11.95;
    kData0.low = 11.32;
    kData0.close = 11.75;
    
    
    KDataModel* kData1 = [[KDataModel alloc]init];
    //    kData1.open = 11.60;
    //    kData1.high = 11.66;
    kData1.low = 11.23;
    kData1.close = 11.57;
    KDataModel* kData2 = [[KDataModel alloc]init];
    kData2.close = 11.75;
    
    
    //    OneDayCondition* theCond = [[OneDayCondition alloc]initWithKData:kData0 baseCloseValue:11.47f];
    OneDayCondition* theCond = [[OneDayCondition alloc]initWithKData:kData1 baseCloseValue:11.75f];
    //    theCond.dvRange = 0.9;
    
    [GSAnalysisManager shareInstance].tp1dayCond = theCond;
    [theCond logOutCondition];
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    //    t0con.open_max = -0.2f;
    //    t0con.open_min = -2.f;
    [GSAnalysisManager shareInstance].t0dayCond = t0con;
    
    return theCond;
}




- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
