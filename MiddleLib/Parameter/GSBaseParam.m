//
//  GSBaseParam.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseParam.h"

@implementation GSBaseParam

-(id)init
{
    if(self = [super init]){
        [self resetForAll];
        
        _destDVValue = 2.5f;
        _stopDVValue = -3.5f;
    }
    
    return self;
}

-(void)resetForAll
{
    self.allResultArray = [NSMutableArray array];
    self.allResultDict = [NSMutableDictionary dictionary];
    self.allTotalCount = 0;
    self.allTotalS2BDVValue = 0;
    
    /*
     Sndday high vs fstday close
     >3%
     >0.8%
     >-1.5%
     >-10%
     */
    for(long i=0; i<4; i++){
        [self.allResultArray addObject:[NSMutableArray array]];
    }
}

-(BOOL)isMapRasingLimitAvgConditon:(KDataModel*)kTP1Data
{
    CGFloat dvMa5AndClose = [[GSDataMgr shareInstance]getDVValueWithBaseValue:kTP1Data.ma5 destValue:kTP1Data.close];
    CGFloat dvMa10AndClose = [[GSDataMgr shareInstance]getDVValueWithBaseValue:kTP1Data.ma10 destValue:kTP1Data.close];
    if(dvMa5AndClose > 6.f
       || dvMa10AndClose < -8.f
       ){
        return NO;
    }
    
    return YES;
}

-(BOOL)isMapRasingLimitAvgConditonMa30:(KDataModel*)kTP1Data
{
    CGFloat dvMa30AndClose = [[GSDataMgr shareInstance]getDVValueWithBaseValue:kTP1Data.ma30 destValue:kTP1Data.close];
    //    CGFloat dvMa10AndClose = [[GSDataMgr shareInstance]getDVValueWithBaseValue:kTP1Data.ma10 destValue:kTP1Data.close];
    if(dvMa30AndClose > 10.f
       //       || dvMa10AndClose < -8.f
       ){
        return NO;
    }
    
    return YES;
}


@end
