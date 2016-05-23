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
    // Insert code here to initialize your applicati
    
    _dir = @"/Users/frankweng/Code/1HelpCode/0数据";
    _stkID = @"600418"; //002481
    
    [GSDataInit shareManager].standardDate = 20110101;
    
    //regsiter net
    [[HYRequestManager sharedInstance]initService];
    
//    [[STKManager shareManager]testGetFriPostsRequest];

//    [[STKManager shareManager]test];
    
    //debug code.
//    [self testFunc];
    [self test2];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}




-(void)test2
{
    
    
//    [self setCodintionCase0Toady];
    
    [[GSAnalysisManager shareManager]analysisFile:_stkID inDir:_dir];
    

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
    
    
    //    OneDayCondition* tp1con = [[OneDayCondition alloc]initWithKData:kData0 baseCloseValue:11.47f];
    OneDayCondition* tp1con = [[OneDayCondition alloc]initWithKData:kData1 baseCloseValue:11.75f];
    //    tp1con.dvRange = 0.9;
    
    [GSAnalysisManager shareManager].tp1dayCond = tp1con;
    [tp1con logOutCondition];
    
    OneDayCondition* t0con = [[OneDayCondition alloc]init];
    //    t0con.open_max = -0.2f;
    //    t0con.open_min = -2.f;
    [GSAnalysisManager shareManager].t0dayCond = t0con;
    
    
    return tp1con;
}








-(NSDate*)parseString:(NSString*)str
{
    NSDate* date ;
    
    
    
    return date;
}

@end
