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

#import "GSBaseAnalysisMgr.h"
#import "GSCondition.h"
#import "HYLog.h"
#import "GSDataMgr.h"

#import "LimitAnalysisMgr.h"

@interface AppDelegate (){
    
    NSString* _filedir;
    NSString* _dbdir;
    NSString* _queryDbdir; //for query result.
    NSString* _stkID;
    
    BOOL _isDoAnalysis;
    
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
    _dbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSStkDB160819.db",[paths stringByDeletingLastPathComponent]];
    _queryDbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSQuery%@.db",[paths stringByDeletingLastPathComponent],strNowDate];

    
    
//    [[HYLog shareInstance] enableLog];
    
    //    [GSDataMgr shareInstance].startDate = 20110101;
    //    [GSDataMgr shareInstance].endDate = 20120101;
    //
    //    [GSDataMgr shareInstance].startDate = 20120101;
    //    [GSDataMgr shareInstance].endDate = 20130101;
    //
    //    [GSDataMgr shareInstance].startDate = 20140101;
    //    [GSDataMgr shareInstance].endDate = 20150101;
    //
    //    [GSDataMgr shareInstance].startDate = 20150101;
    //    [GSDataMgr shareInstance].endDate = 20160101;
    //
    //    [GSDataMgr shareInstance].startDate = 20160101;
    //    [GSDataMgr shareInstance].endDate = 20170101;
    
    
    //regsiter net
    //    [[HYRequestManager sharedInstance]initService];
    //    [[STKManager shareInstance]testGetFriPostsRequest];
    //    [[STKManager shareInstance]test];
    
    
    [self doInit];
}

-(void)doInit{
    
    _isDoAnalysis = YES; //tbd. fix two intance can't both exist.
    
    [GSObjMgr shareInstance].mgr = [[LimitAnalysisMgr alloc]init];
    [GSObjMgr shareInstance].log = [[LimitLogout alloc]init];
    
    if(_isDoAnalysis){
        [[HYDBManager defaultManager]setupDB:_dbdir isReset:NO];
        
        
        //    [[GSDataMgr shareInstance]writeDataToDB:_filedir];
        //    return;
    }else{
        [[QueryDBManager defaultManager]setupDB:_queryDbdir isReset:NO];
    }

    
//    [GSObjMgr shareInstance].mgr.stkRangeArray = @[@"SH600075"];
//    [GSObjMgr shareInstance].mgr.stkRangeArray = @[@"SH600401"];

    [self testForAllLimit];
}



-(void)testForAllLimit
{
//    [GSDataMgr shareInstance].marketType = marketType_ShenZhenChuanYeBan; //
//    [GSDataMgr shareInstance].marketType = marketType_ShenZhenMainAndZhenXiaoBan;
//    [GSDataMgr shareInstance].marketType = marketType_ShangHai;
    [GSDataMgr shareInstance].marketType = marketType_All;
    [GSDataMgr shareInstance].startDate = 20160125;
//    [GSDataMgr shareInstance].startDate = 20160725;
    
    //dbg
    [GSDataMgr shareInstance].startDate = 20160725;


//    //why use as first shareInstance???
//    NSObject* obj1= [[GSObjMgr shareInstance].mgr];
//    NSObject* obj=  [GSObjMgr shareInstance].mgr;

    
    RaisingLimitParam* param = [[RaisingLimitParam alloc]init];
    //tmp best.
    param.daysAfterLastLimit = 15; //30;
    param.buyPercent = 1.03;
    param.destDVValue = 6.f;
    param.durationAfterBuy = 3;
    param.buyStartIndex = 1;
    param.buyEndIndex = 4; //param.buyStartIndex;
    [GSObjMgr shareInstance].mgr.param = param;
    
//    [[[GSObjMgr shareInstance].mgr]queryAllAndSaveToDBWithFile:_filedir];
////    [[[GSObjMgr shareInstance].mgr]queryAllWithDB:_filedir];
//    return;


    
//    param.buyPercent = 0.98;
//    param.destDVValue = 6.f;
    
//    for(long buyIndex = 1; buyIndex<=5; buyIndex++)
    {
//        param.buyStartIndex = buyIndex;
//        param.buyEndIndex = param.buyStartIndex;

        [GSObjMgr shareInstance].mgr.param = param;
        [[GSObjMgr shareInstance].mgr analysisAllInDir:_filedir];
    }
    
    [ [GSObjMgr shareInstance].log analysisAndLogtoFile];

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



-(void)setOpenValue
{
    //    [GSCondition shareInstance].t0Cond = T0Condition_Down;
    
    //    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
    //    tp2con.close_max = 1.f;
    //    tp2con.close_min = -1.2f;
    //    [GSObjMgr shareInstance].mgr.tp2dayCond = tp2con;
    //
    
//    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    tp1con.close_min = -0.5f;
//    tp1con.close_max = 2.f;
//    [GSObjMgr shareInstance].mgr.tp1dayCond = tp1con;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.open_min = 1.0f;
    t0con.open_max = 2.0f;
    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
    
//    [GSCondition shareInstance].shapeCond= ShapeCondition_UpShadow;
    
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    //    t1con.open_max = 0.4f;
    //    t1con.open_min = -0.4f;
    //    t1con.high_max = 2.5f;
    //    t1con.high_min = 1.2f;
    [GSObjMgr shareInstance].mgr.t1dayCond = t1con;
    
    
    //    OneDayCondition* t2con = [[OneDayCondition alloc]init];
    //    t2con.open_max = 1.f;
    //    t2con.open_min = 0.3f;
    //
    //
    //    [GSObjMgr shareInstance].mgr.tp2dayCond = t2con;
}


-(void)setNormalToday
{
//    [GSCondition shareInstance].t0Cond = T0Condition_Down;
    
//    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
//    tp2con.close_max = 1.f;
//    tp2con.close_min = -1.2f;
//    [GSObjMgr shareInstance].mgr.tp2dayCond = tp2con;
//
    
//    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    tp1con.close_min = -4.5f;
//    tp1con.close_max = -3.f;
//    [GSObjMgr shareInstance].mgr.tp1dayCond = tp1con;
//    
//    OneDayCondition* t0con = [[OneDayCondition alloc]init];
//    t0con.close_min = 0.5f;
//    t0con.close_max = 2.0f;
//    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
    
    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
    tp2con.close_min = 1.f;
    tp2con.close_max = 3.f;
    [GSObjMgr shareInstance].mgr.tp2dayCond = tp2con;
    
    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
    tp1con.close_min = 0.5f;
    tp1con.close_max = 2.2f;
    [GSObjMgr shareInstance].mgr.tp1dayCond = tp1con;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_min = -1.f;
    t0con.close_max = 0.3f;
    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    t1con.close_min = -1.f;
    t1con.close_max = 0.3f;
    [GSObjMgr shareInstance].mgr.t1dayCond = t1con;
    
    
//    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    t2con.open_max = 1.5f;
//    t2con.open_min = 0.5f;
//    [GSObjMgr shareInstance].mgr.t2 = t2con;
}



-(void)setUpShadow
{
    //    [GSCondition shareInstance].t0Cond = T0Condition_Down;
    
    //    OneDayCondition* tp2con = [[OneDayCondition alloc]init];
    //    tp2con.close_max = 1.f;
    //    tp2con.close_min = -1.2f;
    //    [GSObjMgr shareInstance].mgr.tp2dayCond = tp2con;
    //
    
//    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
//    tp1con.close_min = -4.5f;
//    tp1con.close_max = -3.f;
//    [GSObjMgr shareInstance].mgr.tp1dayCond = tp1con;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_min = 0.5f;
    t0con.close_max = 2.0f;
    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;

    [GSCondition shareInstance].shapeCond= ShapeCondition_UpShadow;
 
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    //    t1con.open_max = 0.4f;
    //    t1con.open_min = -0.4f;
    //    t1con.high_max = 2.5f;
    //    t1con.high_min = 1.2f;
    [GSObjMgr shareInstance].mgr.t1dayCond = t1con;
    
    
    //    OneDayCondition* t2con = [[OneDayCondition alloc]init];
    //    t2con.open_max = 1.f;
    //    t2con.open_min = 0.3f;
    //
    //
    //    [GSObjMgr shareInstance].mgr.tp2dayCond = t2con;
}




-(void)setNormalDown
{
    [GSCondition shareInstance].t0Cond = T0Condition_Down;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_max = -2.0f;
    t0con.close_min = -3.5f;
    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
    
    OneDayCondition* t1con = [[OneDayCondition alloc]init];
    t1con.open_max = 1.f;
    t1con.open_min = -1.f;
    t1con.high_max = 2.5f;
    t1con.high_min = 1.2f;
//    t1con.close_max = -0.6f;
//    t1con.close_min = -1.8f;
    [GSObjMgr shareInstance].mgr.t1dayCond = t1con;
    
    
//    OneDayCondition* t2con = [[OneDayCondition alloc]init];
//    t2con.open_max = 1.f;
//    t2con.open_min = 0.3f;
//    
//    
//    [GSObjMgr shareInstance].mgr.tp2dayCond = t2con;
}


-(void)setNormalUp
{
    [GSCondition shareInstance].t0Cond = T0Condition_Up;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_max = 2.5f;
    t0con.close_min = 1.3f;
    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
    
//    OneDayCondition* t1con = [[OneDayCondition alloc]init];
////    t1con.open_max = -0.1f;
////    t1con.open_min = -1.f;
////    t1con.open_max = 1.1f;
////    t1con.open_min = 0.f;
//    t1con.close_max = -0.6f;
//    t1con.close_min = -1.8f;
//    [GSObjMgr shareInstance].mgr.t1dayCond = t1con;
    
    
    OneDayCondition* t2con = [[OneDayCondition alloc]init];
        t2con.open_max = 1.f;
        t2con.open_min = 0.3f;


    [GSObjMgr shareInstance].mgr.tp2dayCond = t2con;
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
    
    [GSObjMgr shareInstance].mgr.tp1dayCond = theCond;
    [theCond logOutCondition];
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    //    t0con.open_max = -0.2f;
    //    t0con.open_min = -2.f;
    [GSObjMgr shareInstance].mgr.t0dayCond = t0con;
    
    return theCond;
}




- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
