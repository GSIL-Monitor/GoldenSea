//
//  KDataService.h
//  GSGoldenSea
//
//  Created by frank weng on 16/3/2.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYBaseDBService.h"

@interface TKData : HYBaseDBService

- (NSArray *)getRecords:(long)startTime end:(long)endTime;

@end