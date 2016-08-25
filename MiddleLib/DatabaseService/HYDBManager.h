//
//  HYDBManager.h
//  HYBaseProject
//
//  Created by frank weng on 16/6/21.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDataDBService.h"


@interface HYDBManager : NSObject

+(HYDBManager *)defaultManager;

+(NSString*)defaultDBPath;

- (void)setupDB:(NSString*)dbPath isReset:(BOOL)isReset;;
- (BOOL)closeDB;

-(KDataDBService*)dbserviceWithSymbol:(NSString*)symbol;

@end
