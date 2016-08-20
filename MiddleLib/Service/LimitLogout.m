//
//  LimitLogout.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "LimitLogout.h"
#import "GSAnalysisManager.h"

@implementation LimitLogout

SINGLETON_GENERATOR(LimitLogout, shareInstance);


-(void)logOutAllResult
{
    SMLog(@"LogOutAllResult - destDV(%.2f) -totalCount(%d) --alltotalS2BDVValue(%2f)",[GSAnalysisManager shareInstance].destDVValue,[GSAnalysisManager shareInstance].allTotalCount,[GSAnalysisManager shareInstance].allTotalS2BDVValue);
    [self _SimpleLogOutForAll:YES isJustLogFail:NO];
}


@end
