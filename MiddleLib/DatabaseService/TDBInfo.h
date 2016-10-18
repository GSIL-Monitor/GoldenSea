//
//  TDBInfo.h
//  GSGoldenSea
//
//  Created by frank weng on 16/8/26.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYBaseDBService.h"

@interface DBInfoModel : HYBaseModel

@property (strong) NSString* version;
@property (assign) long lastUpdateTime;

@end


@interface TDBInfo : HYBaseDBService


-(DBInfoModel*)getRecord;
-(BOOL)updateTime:(long)updateTime;

@end
