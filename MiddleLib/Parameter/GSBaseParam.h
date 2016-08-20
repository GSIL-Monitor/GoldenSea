//
//  GSBaseParam.h
//  GSGoldenSea
//
//  Created by frank weng on 16/8/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  for record the analysis param and result.
 */
@interface GSBaseParam : NSObject

//for result
@property (nonatomic,strong) NSMutableArray* allResultArray;
@property (nonatomic,strong) NSMutableDictionary* allResultDict;
@property (assign) int allTotalCount;
@property (nonatomic, assign) CGFloat allTotalS2BDVValue;



//condition
@property (assign) CGFloat destDVValue; //目标位
@property (assign) CGFloat cutDVValue; //止损位

@property (assign) long durationAfterBuy; //the duaration(t+n day) after the buy day.



//检测kTP1Data的数据是否满足MA5和MA10的要求，即不能超出太多
-(BOOL)isMapRasingLimitAvgConditon:(KDataModel*)kTP1Data;

//检测kTP1Data的数据是否满足MA30的要求，即不能超出太多
-(BOOL)isMapRasingLimitAvgConditonMa30:(KDataModel*)kTP1Data;

@end