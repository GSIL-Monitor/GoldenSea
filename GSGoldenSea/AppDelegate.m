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


@interface AppDelegate (){
    
    NSString* _dir;
    NSString* _stkID;

}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    
    _dir = @"/Users/frankweng/Code/1HelpCode/0数据";
//    _dir = @"/Users/fieldwind/Code/1HelpCode/0数据";
    _stkID = @"600418"; //jhqc
//    _stkID = @"002298"; //stsp
//    _stkID = @"002481";
//    _stkID = @"000592"; //ptfz
    _stkID = @"SH#000001";
    
    [GSDataInit shareManager].standardDate = 20110101;
    
    //regsiter net
//    [[HYRequestManager sharedInstance]initService];
//    [[STKManager shareManager]testGetFriPostsRequest];
//    [[STKManager shareManager]test];
    

    [self test2];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}




-(void)test2
{
    //    [self setCodintionCase0Toady];
//    [self setNormalUp];
//    [GSCondition shareManager].shapeCond = ShapeCondition_HengPan_6Day;
    
//    [self setNormalDown];
    
    [self setNormalToday];
    
    [[GSAnalysisManager shareManager]analysisFile:_stkID inDir:_dir];
}


-(void)setNormalToday
{
//    [GSCondition shareManager].t0Cond = T0Condition_Down;
    
    OneDayCondition* tp1con = [[OneDayCondition alloc]init];
    tp1con.close_max = 0.8f;
    tp1con.close_min = -0.6f;
    [GSAnalysisManager shareManager].tp1dayCond = tp1con;
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    t0con.close_max = 4.0f;
    t0con.close_min = 2.5f;
    [GSAnalysisManager shareManager].t0dayCond = t0con;
    
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








@end
