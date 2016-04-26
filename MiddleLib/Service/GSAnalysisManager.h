//
//  GSFileManager.h
//  GSGoldenSea
//
//  Created by frank weng on 16/4/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSAnalysisManager : NSObject

+(GSAnalysisManager*)shareManager;


-(void)analysis:(NSString*)stkUUID inDir:(NSString*)docsDir;

@end
