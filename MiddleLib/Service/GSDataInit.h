//
//  GSDataInit.h
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSDataInit : NSObject
+(GSDataInit*)shareManager;


@property (nonatomic,strong) NSString* currStkUUID;
@property (nonatomic,strong) NSString* currStkFilePath;
@property (nonatomic,strong) NSMutableArray* contentArray;


@property (assign) int standardDate; //start analysis date, such as 20140101


-(NSArray*)buildDataWithStkUUID:(NSString*)stkUUID inDir:(NSString*)docsDir;

@end
