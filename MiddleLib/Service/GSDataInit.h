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


@property (nonatomic,strong) NSMutableArray* contentArray;
@property (nonatomic,strong) NSMutableArray* sourceFileArray;


@property (assign) int standardDate; //start analysis date, such as 20140101


-(NSArray*)buildDataWithStkUUID:(NSString*)stkUUID inDir:(NSString*)docsDir;
-(NSMutableArray*)findSourcesInDir:(NSString*)docsDir;
-(NSMutableArray*)getStkContentArray:(NSString*)filePath;

@end
