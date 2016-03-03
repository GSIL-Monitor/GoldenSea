//
//  AppDelegate.m
//  GSGoldenSea
//
//  Created by frank weng on 16/2/26.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "AppDelegate.h"

#import "HYRequestManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    //regsiter net
    [[HYRequestManager sharedInstance]initService];
    
    
    //debug code.
    [self testFunc];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}



-(void)testFunc
{
    NSDate* dnow = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time = [dnow timeIntervalSince1970];
    
    
    time = 1456490307755;
    time = 1424954307755;
    NSString* tstring = @"Fri Feb 27 00:00:00 +0800 2015";
    
    NSDate* d2 = [NSDate dateWithTimeIntervalSince1970:time];
    
    
    
    NSLog(@"bb");

}

@end
