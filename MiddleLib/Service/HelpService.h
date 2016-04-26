//
//  HelpService.h
//  GSGoldenSea
//
//  Created by frank weng on 16/3/3.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpService : NSObject
+(NSString*)savePath:(NSString*)fileName;
+(BOOL)saveContent:(NSString*)content withName:(NSString*)fileName;

@end
