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

-(void)_dispatchResult2Array:(KDataModel*)kT0data buy:(CGFloat)buyValue sell:(CGFloat)sellValue;


@end
