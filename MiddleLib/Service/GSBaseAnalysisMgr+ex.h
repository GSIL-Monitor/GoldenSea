//
//  GSBaseAnalysisMgr+ex.h
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseAnalysisMgr.h"


@interface GSBaseAnalysisMgr (ex)

-(BOOL)isValidDataPassedIn;

-(void)resetForOne;



-(void)dispatchResult2Array:(KDataModel*)kT0data buyValue:(CGFloat)buyValue sellValue:(CGFloat)sellValue;
-(void)NSTKdispResult2Array:(KDataModel*)kT0data buyValue:(CGFloat)buyValue sellValue:(CGFloat)sellValue;

-(BOOL)isInRange:(NSString*)stkID rangeArray:(NSArray*)rangeArray;
-(BOOL)isInRange:(NSString*)stkID;


@end
