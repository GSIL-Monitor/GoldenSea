//
//  GSGlobalObjMgr.h
//  GSGoldenSea
//
//  Created by frank weng on 16/8/22.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GSBaseAnalysisMgr.h"

@interface GSObjMgr : NSObject

@property (nonatomic, strong) GSBaseAnalysisMgr* mgr;
@property (nonatomic, strong) GSBaseLogout* log;

+(GSObjMgr*)shareInstance;

@end
