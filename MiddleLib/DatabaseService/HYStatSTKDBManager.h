//
//  HYStatSTKDBManager.h
//  GSGoldenSea
//
//  Created by frank weng on 17/2/24.
//  Copyright © 2017年 frank weng. All rights reserved.
//

#import "HYBaseDBManager.h"

@interface HYStatSTKDBManager : HYBaseDBManager

+(HYStatSTKDBManager *)defaultManager;

@property (nonatomic, strong) TStatSTK* allSTK;


@end
