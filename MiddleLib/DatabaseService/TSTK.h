//
//  STKDBService.h
//  GSGoldenSea
//
//  Created by frank weng on 16/3/4.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYBaseDBService.h"

@interface TSTK : HYBaseDBService

+(TSTK*)shareInstance;


-(BOOL)updateTime:(long)updateTime WithID:(NSString *)recordID;

@end
