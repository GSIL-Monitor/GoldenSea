//
//  GSBaseParam.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseParam.h"

@implementation KeyTimeObj


@end

@implementation GSBaseParam

-(id)init
{
    if(self = [super init]){
        [self resetForAll];
        
        _destDVValue = 2.5f;
        _cutDVValue = kInvalidData_Base;
    }
    
    return self;
}

-(void)resetForAll
{
//    self.selResultArray = [NSMutableArray array];
//    self.selResultDict = [NSMutableDictionary dictionary];
//    self.selTotalCount = 0;
//    self.selTotalS2BDVValue = 0;
//    
//    /*
//     Sndday high vs fstday close
//     >3%
//     >0.8%
//     >-1.5%
//     >-10%
//     */
//    for(long i=0; i<4; i++){
//        [self.selResultArray addObject:[NSMutableArray array]];
//    }
    
    self.totalCount = 0;
    self.totalS2BDVValue = 0;
    self.resultArray = [NSMutableArray array];
    for(long i=0; i<3; i++){
        [self.resultArray addObject:[NSMutableArray array]];
    }
}

-(CGFloat)getSucPecent;
{
    NSArray* sucArray = [self.resultArray safeObjectAtIndex:0];
    NSUInteger sucCount = [sucArray count];
    return  sucCount*100.f/self.totalCount;
}

-(BOOL)isMapRasingLimitAvgConditon:(KDataModel*)kTP1Data
{
    CGFloat dvMa5AndClose = [UtilData getDVValueWithBaseValue:kTP1Data.ma5 destValue:kTP1Data.close];
    CGFloat dvMa10AndClose = [UtilData getDVValueWithBaseValue:kTP1Data.ma10 destValue:kTP1Data.close];
    if(dvMa5AndClose > 6.f
       || dvMa10AndClose < -8.f
       ){
        return NO;
    }
    
    return YES;
}

-(BOOL)isMapRasingLimitAvgConditonMa30:(KDataModel*)kTP1Data
{
    CGFloat dvMa30AndClose = [UtilData getDVValueWithBaseValue:kTP1Data.ma30 destValue:kTP1Data.close];
//        CGFloat dvMa10AndClose = [[GSDataMgr shareInstance]getDVValueWithBaseValue:kTP1Data.ma10 destValue:kTP1Data.close];
    if(dvMa30AndClose > 10.f
//              || dvMa10AndClose < -8.f
       ){
        return NO;
    }
    
    return YES;
}



#pragma mark - copy
-(id)copyWithZone:(NSZone *)zone
{
    GSBaseParam* one = [self.class new];
    
    //copy condition
    one.destDVValue = _destDVValue;
    one.cutDVValue = _cutDVValue;
    one.durationAfterBuy = _durationAfterBuy;
    
    //reset result
    one.resultArray = [NSMutableArray array];
    for(long i=0; i<3; i++){
        [one.resultArray addObject:[NSMutableArray array]];
    }
    one.totalCount = 0;
    one.totalS2BDVValue = 0;
    
    return one;
}



@end
