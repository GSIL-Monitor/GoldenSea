//
//  LimitLogout.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "LimitLogout.h"
#import "GSBaseAnalysisMgr.h"


@interface LimitLogout ()

@end

@implementation LimitLogout



-(void)logOutAllResult
{
    [self _SimpleLogOutForAll:YES isJustLogFail:NO];
}


-(void)analysisAndLogtoFile;
{
    [[HYLog shareInstance] enableLog];
    
    
//    SMLog(@"LogOutAllResult - destDV(%.2f) -totalCount(%d) --alltotalS2BDVValue(%2f)",[GSBaseAnalysisMgr shareInstance].destDVValue,[GSBaseAnalysisMgr shareInstance].allTotalCount,[GSBaseAnalysisMgr shareInstance].allTotalS2BDVValue);

    
    
    [[HYLog shareInstance] disableLog];
}

@end
