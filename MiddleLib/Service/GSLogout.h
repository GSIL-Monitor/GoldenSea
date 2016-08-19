//
//  GSLogout.h
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSLogout : NSObject

+(GSLogout*)shareManager;

-(void)logOutResult;

-(void)logOutAllResult;


-(void)SimpleLogOutResult:(BOOL)isJustLogFail;

@end
