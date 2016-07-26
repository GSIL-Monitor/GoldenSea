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
#import "KDataDBService.h"

#import "STKManager.h"

#import "GSAnalysisManager.h"
#import "GSCondition.h"
#import "HYLog.h"
#import "GSDataInit.h"

@interface AppDelegate (){
    
    NSString* _dir;
    NSString* _stkID;

}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
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
    _dir = @"/Users/frankweng/Code/1HelpCode/0数据/data20160523";
    //    _dir = @"/Users/fieldwind/Code/1HelpCode/0数据/export";
    _stkID = @"600418"; //jhqc
    //    _stkID = @"002298"; //stsp
    //    _stkID = @"002481";
    //    _stkID = @"000592"; //ptfz
    //    _stkID = @"000751"; //
    //    _stkID = @"SH#000001";
    //    _stkID = @"600807"; //tygf
    //    _stkID = @"SH#601002";
    //    _stkID = @"SH#600126"; //hggf
    _stkID = @"002430"; //hygf
//    _stkID = @"002654"; //for test use.
    
   
    
#if 0
    [self testForOne];
#else
    [self testForAll];
#endif
}





-(void)testForAll
{
    //    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
    //    tp2con.close_max = 1.f;
    //    tp2con.close_min = -1.2f;
    //    [GSAnalysisManager shareManager].tp2dayCond = tp2con;
    //
    //    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
    //    tp1con.close_max = 0.5f;
    //    tp1con.close_min = -1.2f;
    //    [GSAnalysisManager shareManager].tp1dayCond = tp1con;
    
//    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    t0con.close_max = -0.f;
//    t0con.close_min = -1.f;
//    [GSAnalysisManager shareManager].t0dayCond = t0con;
//    
//    [self setOpenValue];
//
//    
//
    
    [GSDataInit shareManager].marketType = marketType_ShenZhenMainAndZhenXiaoBan;
    
    [GSAnalysisManager shareManager].destDVValue = 5.f;
    [[GSAnalysisManager shareManager]analysisAllInDir:_dir];
    
    
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
    [[GSAnalysisManager shareManager]_analysisFile:_stkID inDir:_dir];
    

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
