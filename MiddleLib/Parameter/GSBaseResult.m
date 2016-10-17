//
//  GSBaseResult.m
//  GSGoldenSea
//
//  Created by frank weng on 16/10/17.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseResult.h"

@implementation GSBaseResult

-(id)init
{
    if(self = [super init]){
        [self resetForAll];
        
    }
    
    return self;
}


-(void)resetForAll
{
    self.resultDict = [NSMutableDictionary dictionary];
}


-(NSMutableArray*)paramArrayWithSymbol:(NSString*)symbol
{
    NSMutableArray* paramArray = [self.resultDict safeValueForKey:symbol];
    if(!paramArray){
        paramArray = [[NSMutableArray alloc]init];
        [self.resultDict safeSetValue:paramArray forKey:symbol];
    }
    
    return paramArray;
}


-(void)setSTK:(NSString*)stkID pararm:(GSBaseParam*)param;
{
    NSMutableArray* paramArray = [self paramArrayWithSymbol:stkID];
    [paramArray addObject:param];
}



@end
