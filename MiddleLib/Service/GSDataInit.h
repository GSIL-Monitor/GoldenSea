//
//  GSDataInit.h
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDataModel.h"

@interface GSDataInit : NSObject
+(GSDataInit*)shareManager;


@property (nonatomic,strong) NSMutableArray* contentArray;
@property (nonatomic,strong) NSMutableArray* sourceFileArray;


@property (assign) int standardDate; //start analysis date, such as 20140101


-(NSArray*)buildDataWithStkUUID:(NSString*)stkUUID inDir:(NSString*)docsDir;
-(NSMutableArray*)findSourcesInDir:(NSString*)docsDir;
-(NSMutableArray*)getStkContentArray:(NSString*)filePath;


-(DVValue*)getDVValue:(NSArray*)tmpContentArray baseIndex:(long)baseIndex destIndex:(long)destIndex;
-(DVValue*)getAvgDVValue:(NSUInteger)days array:(NSArray*)tmpContentArray index:(long)index;
-(CGFloat)getMAValue:(NSUInteger)days array:(NSArray*)tmpContentArray t0Index:(long)t0Index;


@end
