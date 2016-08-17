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

#import "STKManager.h"

#import "GSAnalysisManager.h"
#import "GSCondition.h"
#import "HYLog.h"
#import "GSDataInit.h"

@interface AppDelegate (){
    
    NSString* _filedir;
    NSString* _dbdir;
    NSString* _stkID;

}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    _filedir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/KDay",[paths stringByDeletingLastPathComponent]];
    _dbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSStkDB160801.db",[paths stringByDeletingLastPathComponent]];


    
    [[HYDBManager defaultManager]setupDB:_dbdir isReset:NO];
    
//    [[GSDataInit shareManager]writeDataToDB:_filedir];
//    return;
    
//    [[HYLog shareManager] enableLog];
    
    //    [GSDataInit shareManager].startDate = 20110101;
    //    [GSDataInit shareManager].endDate = 20120101;
    //
    //    [GSDataInit shareManager].startDate = 20120101;
    //    [GSDataInit shareManager].endDate = 20130101;
    //
    //    [GSDataInit shareManager].startDate = 20140101;
    //    [GSDataInit shareManager].endDate = 20150101;
    //
    //    [GSDataInit shareManager].startDate = 20150101;
    //    [GSDataInit shareManager].endDate = 20160101;
    //
    //    [GSDataInit shareManager].startDate = 20160101;
    //    [GSDataInit shareManager].endDate = 20170101;
    
    
    //regsiter net
    //    [[HYRequestManager sharedInstance]initService];
    //    [[STKManager shareManager]testGetFriPostsRequest];
    //    [[STKManager shareManager]test];
    
    [self doInit];
    
}

-(void)doInit{

    _stkID = @"SH600418"; //jhqc
    
    //    _stkID = @"SH601002";
    //    _stkID = @"SH600126"; //hggf
//    _stkID = @"SZ002430"; //hygf
    _stkID = @"SZ000912"; //泸天化
//    _stkID = @"SZ300460";


    
#if 0
    [self testForOne];
#else
    [self testForAll];
#endif
}





-(void)testForAll
{
   
    [RaisingLimitParam shareInstance].durationAfterBuy = 3;
    [RaisingLimitParam shareInstance].buyPercent = 0.95;
    
    
//    [GSDataInit shareManager].marketType = marketType_ShenZhenChuanYeBan; //
//    [GSDataInit shareManager].marketType = marketType_ShenZhenMainAndZhenXiaoBan;
//    [GSDataInit shareManager].marketType = marketType_ShangHai;
    [GSDataInit shareManager].marketType = marketType_All;

    [GSDataInit shareManager].startDate = 20160125;
//    [GSDataInit shareManager].startDate = 20160725;
    
//    [GSAnalysisManager shareManager].destDVValue = 5.f;
//    [[GSAnalysisManager shareManager]analysisAllInDir:_filedir];
//    return;

//    [GSAnalysisManager shareManager].destDVValue = 10.f;
//    [[GSAnalysisManager shareManager]analysisAllInDir:_filedir];

//    for(long i=3; i<15; i++)
    for(long i=3; i<12; i++)
    {
        [GSAnalysisManager shareManager].destDVValue = 1.f*i;
        
        [[GSAnalysisManager shareManager]analysisAllInDir:_filedir];

    }
    
    
    
}




-(void)testForOne
{
    //    [self setCodintionCase0Toady];
//    [self setNormalUp];
//    [GSCondition shareManager].shapeCond = ShapeCondition_HengPan_6Day;
    
//    [self setNormalDown];
    
//    [self setNormalToday];
    
//    [self setUpShadow];
    
    
//    [self setOpenValue];
    
//    [GSCondition shareManager].shapeCond= ShapeCondition_MA5UpMA10;
//    
    [[GSAnalysisManager shareManager]_analysisFile:_stkID inDir:_filedir];
    

}



-(void)setOpenValue
{
    //    [GSCondition shareManager].t0Cond = T0Condition_Down;
    
    //    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
    //    tp2con.close_max = 1.f;
    //    tp2con.close_min = -1.2f;
    //    [GSAnalysisManager shareManager].tp2dayCond = tp2con;
    //
    
//    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    tp1con.close_min = -0.5f;
//    tp1con.close_max = 2.f;
//    [GSAnalysisManager shareManager].tp1dayCond = tp1con;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.open_min = 1.0f;
    t0con.open_max = 2.0f;
    [GSAnalysisManager shareManager].t0dayCond = t0con;
    
//    [GSCondition shareManager].shapeCond= ShapeCondition_UpShadow;
    
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    //    t1con.open_max = 0.4f;
    //    t1con.open_min = -0.4f;
    //    t1con.high_max = 2.5f;
    //    t1con.high_min = 1.2f;
    [GSAnalysisManager shareManager].t1dayCond = t1con;
    
    
    //    OneDayCondition* t2con = [[OneDayCondition alloc]init];
    //    t2con.open_max = 1.f;
    //    t2con.open_min = 0.3f;
    //
    //
    //    [GSAnalysisManager shareManager].tp2dayCond = t2con;
}


-(void)setNormalToday
{
//    [GSCondition shareManager].t0Cond = T0Condition_Down;
    
//    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
//    tp2con.close_max = 1.f;
//    tp2con.close_min = -1.2f;
//    [GSAnalysisManager shareManager].tp2dayCond = tp2con;
//
    
//    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    tp1con.close_min = -4.5f;
//    tp1con.close_max = -3.f;
//    [GSAnalysisManager shareManager].tp1dayCond = tp1con;
//    
//    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    t0con.close_min = 0.5f;
//    t0con.close_max = 2.0f;
//    [GSAnalysisManager shareManager].t0dayCond = t0con;
    
    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
    tp2con.close_min = 1.f;
    tp2con.close_max = 3.f;
    [GSAnalysisManager shareManager].tp2dayCond = tp2con;
    
    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
    tp1con.close_min = 0.5f;
    tp1con.close_max = 2.2f;
    [GSAnalysisManager shareManager].tp1dayCond = tp1con;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_min = -1.f;
    t0con.close_max = 0.3f;
    [GSAnalysisManager shareManager].t0dayCond = t0con;
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    t1con.close_min = -1.f;
    t1con.close_max = 0.3f;
    [GSAnalysisManager shareManager].t1dayCond = t1con;
    
    
//    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    t2con.open_max = 1.5f;
//    t2con.open_min = 0.5f;
//    [GSAnalysisManager shareManager].t2 = t2con;
}



-(void)setUpShadow
{
    //    [GSCondition shareManager].t0Cond = T0Condition_Down;
    
    //    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
    //    tp2con.close_max = 1.f;
    //    tp2con.close_min = -1.2f;
    //    [GSAnalysisManager shareManager].tp2dayCond = tp2con;
    //
    
//    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    tp1con.close_min = -4.5f;
//    tp1con.close_max = -3.f;
//    [GSAnalysisManager shareManager].tp1dayCond = tp1con;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_min = 0.5f;
    t0con.close_max = 2.0f;
    [GSAnalysisManager shareManager].t0dayCond = t0con;

    [GSCondition shareManager].shapeCond= ShapeCondition_UpShadow;
 
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    //    t1con.open_max = 0.4f;
    //    t1con.open_min = -0.4f;
    //    t1con.high_max = 2.5f;
    //    t1con.high_min = 1.2f;
    [GSAnalysisManager shareManager].t1dayCond = t1con;
    
    
    //    OneDayCondition* t2con = [[OneDayCondition alloc]init];
    //    t2con.open_max = 1.f;
    //    t2con.open_min = 0.3f;
    //
    //
    //    [GSAnalysisManager shareManager].tp2dayCond = t2con;
}




-(void)setNormalDown
{
    [GSCondition shareManager].t0Cond = T0Condition_Down;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_max = -2.0f;
    t0con.close_min = -3.5f;
    [GSAnalysisManager shareManager].t0dayCond = t0con;
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    t1con.open_max = 1.f;
    t1con.open_min = -1.f;
    t1con.high_max = 2.5f;
    t1con.high_min = 1.2f;
//    t1con.close_max = -0.6f;
//    t1con.close_min = -1.8f;
    [GSAnalysisManager shareManager].t1dayCond = t1con;
    
    
//    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    t2con.open_max = 1.f;
//    t2con.open_min = 0.3f;
//    
//    
//    [GSAnalysisManager shareManager].tp2dayCond = t2con;
}


-(void)setNormalUp
{
    [GSCondition shareManager].t0Cond = T0Condition_Up;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_max = 2.5f;
    t0con.close_min = 1.3f;
    [GSAnalysisManager shareManager].t0dayCond = t0con;
    
//    OneDayCondition* t1con = [[OneDayCondition alloc]init];
////    t1con.open_max = -0.1f;
////    t1con.open_min = -1.f;
////    t1con.open_max = 1.1f;
////    t1con.open_min = 0.f;
//    t1con.close_max = -0.6f;
//    t1con.close_min = -1.8f;
//    [GSAnalysisManager shareManager].t1dayCond = t1con;
    
    
    OneDayCondition* t2con = [[OneDayCondition alloc]init];
        t2con.open_max = 1.f;
        t2con.open_min = 0.3f;


    [GSAnalysisManager shareManager].tp2dayCond = t2con;
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
    
    [GSAnalysisManager shareManager].tp1dayCond = theCond;
    [theCond logOutCondition];
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    //    t0con.open_max = -0.2f;
    //    t0con.open_min = -2.f;
    [GSAnalysisManager shareManager].t0dayCond = t0con;
    
    return theCond;
}




- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
