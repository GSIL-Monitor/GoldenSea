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
-(void)logOutResultForStk:(NSString*)stkID;

-(void)SimpleLogOutResult:(BOOL)isJustLogFail;

@end
