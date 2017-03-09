//
//  HYBaseDBManager.h
//  GSGoldenSea
//
//  Created by frank weng on 16/9/18.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HYDatabaseHelper.h"

#import "TSTK.h"
#import "TDBInfo.h"
#import "TKData.h"
#import "TStatSTK.h"


@interface HYBaseDBManager : NSObject

@property (nonatomic, strong) HYDatabaseHelper        *DBHelper;
@property (nonatomic, strong) TDBInfo* dbInfo;

-(NSString*)defaultDBPath;

- (void)setupDB:(NSString*)dbPath isReset:(BOOL)isReset;;
- (BOOL)closeDB;

-(TKData*)dbserviceWithSymbol:(NSString*)symbol;

@end
