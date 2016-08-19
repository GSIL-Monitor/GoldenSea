//
//  GSAnalysisManager+ex.h
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSAnalysisManager.h"

@interface GSAnalysisManager (ex)

-(BOOL)isValidDataPassedIn;

-(void)resetForOne;
-(void)resetForAll;


-(void)dispatchResult2Array:(KDataModel*)kT0data buyIndex:(long)buyIndex sellIndex:(long)sellIndex;

-(void)dispatchResult2Array:(KDataModel*)kT0data buyValue:(CGFloat)buyValue sellValue:(CGFloat)sellValue;

-(BOOL)isInRange:(NSString*)stkID;


@end
