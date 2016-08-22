//
//  GSBaseParam.h
//  GSGoldenSea
//
//  Created by frank weng on 16/8/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyTimeObj : NSObject
@property (nonatomic, assign) CGFloat totalVal;
@property (nonatomic, assign) long totalDays;
@property (nonatomic, assign) CGFloat avgVal;
@end


/**
 *  for record the analysis param and result.
 */
@interface GSBaseParam : NSObject

//for result
//选择后的结果队列，排除了日期的机会成本.但是存在选择的不确定性
@property (nonatomic,strong) NSMutableArray* selResultArray;
@property (assign) int selTotalCount;
@property (nonatomic, assign) CGFloat selTotalS2BDVValue;
@property (nonatomic,strong) NSMutableDictionary* selResultDict;
@property (nonatomic, assign) CGFloat selAvgS2BDVValue; //平均每次收益率


//原始结果
@property (nonatomic,strong) NSMutableArray* allResultArray;
@property (assign) int allTotalCount;
@property (nonatomic, assign) CGFloat allTotalS2BDVValue;
@property (nonatomic, assign) CGFloat allAvgS2BDVValue; //平均每次收益率
@property (nonatomic,strong) NSMutableDictionary* allResultDict;


//condition
@property (assign) CGFloat destDVValue; //目标位
@property (assign) CGFloat cutDVValue; //止损位

@property (assign) long durationAfterBuy; //the duaration(t+n day) after the buy day.



//检测kTP1Data的数据是否满足MA5和MA10的要求，即不能超出太多
-(BOOL)isMapRasingLimitAvgConditon:(KDataModel*)kTP1Data;

//检测kTP1Data的数据是否满足MA30的要求，即不能超出太多
-(BOOL)isMapRasingLimitAvgConditonMa30:(KDataModel*)kTP1Data;


-(void)calcSelAvg;

@end
