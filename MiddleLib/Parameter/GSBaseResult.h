//
//  GSBaseResult.h
//  GSGoldenSea
//
//  Created by frank weng on 16/10/17.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSBaseParam.h"

@interface GSBaseResult : NSObject

//stk -> pararyarray
@property (nonatomic,strong) NSMutableDictionary* resultDict;

//one stk, one paramArray
//@property (nonatomic, strong) NSMutableArray* paramArray;


-(void)setSTK:(NSString*)stkID pararm:(GSBaseParam*)param;

-(NSMutableArray*)paramArrayWithSymbol:(NSString*)symbol;

@end
