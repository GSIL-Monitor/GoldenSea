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

#import "STKManager.h"

#import "GSBaseAnalysisMgr.h"
#import "GSCondition.h"
#import "HYLog.h"
#import "GSDataMgr.h"

#import "LimitAnalysisMgr.h"
#import "AvgAnalysisMgr.h"
#import "TechAnalysisMgr.h"
#import "GSBaseResult.h"

#import "STKxlsReader.h"

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
//    [[QueryDBManager defaultManager]setupDB:_queryDbdir isReset:isRest];
    
//    [self test];


}


-(void)test
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* xlsPath = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/test.xlsx",[paths stringByDeletingLastPathComponent]];
//    NSString* xlsPath = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/test1.xls",[paths stringByDeletingLastPathComponent]];

    [[STKxlsReader shareInstance] startWithPath:xlsPath dbPath:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
