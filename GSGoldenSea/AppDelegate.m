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
#import "HYDayDBManager.h"
#import "TKData.h"
#import "QueryDBManager.h"
#import "HYSTKDBManager.h"

#import "STKManager.h"

#import "GSBaseAnalysisMgr.h"
#import "GSCondition.h"
#import "HYLog.h"
#import "GSDataMgr.h"

#import "LimitAnalysisMgr.h"
#import "AvgAnalysisMgr.h"
#import "TechAnalysisMgr.h"
#import "GSBaseResult.h"


@interface AppDelegate (){
    
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    //get data.
    
    BOOL isRest = NO;
    [[HYDayDBManager defaultManager]setupDB:nil isReset:isRest];
    [[HYWeekDBManager defaultManager]setupDB:nil isReset:isRest];
    [[HYMonthDBManager defaultManager]setupDB:nil isReset:isRest];
    
    [[HYNewSTKDayDBManager defaultManager]setupDB:nil isReset:isRest];

    
//    [[QueryDBManager defaultManager]setupDB:_queryDbdir isReset:isRest];
    
    [[HYSTKDBManager defaultManager]setupDB:nil isReset:isRest];

    [self test];

}

-(void)test
{
    NSArray* arr = [[HYSTKDBManager defaultManager].allSTK getSTKWithStartTime:20161001 endTime:20161101];
    SMLog(@"");
}




- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
