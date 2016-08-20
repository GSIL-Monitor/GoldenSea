//
//  GSLogout.h
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSBaseLogout : NSObject

+(GSBaseLogout*)shareInstance;



//interface
-(void)logOutResult;

-(void)logOutAllResult;


-(void)SimpleLogOutResult:(BOOL)isJustLogFail;


-(void)analysisAndLogtoFile;



//protected.

-(void)_SimpleLogOutForAll:(BOOL)isForAll isJustLogFail:(BOOL)isJustLogFail;


@end
