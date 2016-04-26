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


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
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
    NSString* dir = @"/Users/frankweng/Code/1HelpCode/0数据";
    
    OneDayCondition tp1con;
    tp1con.close_max = -6.f;
    tp1con.close_min = -11.f;
    [GSAnalysisManager shareManager].tp1dayCond = tp1con;
    
    [GSAnalysisManager shareManager].DVUnitOfT0DayOpenAndTP1DayClose = 100; //0

    [[GSAnalysisManager shareManager]parseFile:@"600418" inDir:dir];
}


-(void)testFunc
{
    
    
    NSDate* dnow = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time = [dnow timeIntervalSince1970];
    
    
    time = 1456490307755;
    time = 1424954307755;
    
    time = 1456037755;
    time = 1425437755;


    NSString* tstring = @"Fri Feb 27 00:00:00 +0800 2015";
    
    NSDate* d2 = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDate* d3 = [self parseString:tstring];
    
    NSLog(@"bb");

    
}

-(NSDate*)parseString:(NSString*)str
{
    NSDate* date ;
    
    
    
    return date;
}

@end
