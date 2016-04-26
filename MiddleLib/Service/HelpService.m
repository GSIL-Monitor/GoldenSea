//
//  HelpService.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/3.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HelpService.h"

@implementation HelpService

+(NSString*)savePath:(NSString*)fileName
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString* serverDir = [NSString stringWithFormat:@"%@/GoldenDoc",paths];
    NSString* filePath = [NSString stringWithFormat:@"%@/GoldenDoc/%@",paths,fileName];

    NSFileManager* defaultManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if(![defaultManager fileExistsAtPath: serverDir isDirectory:&isDirectory] || !isDirectory)
        [defaultManager createDirectoryAtPath:serverDir withIntermediateDirectories:YES attributes:NULL error:NULL];
    
    
    return filePath;
}


+(BOOL)saveContent:(NSString*)content withName:(NSString*)fileName;
{
    BOOL res;
    NSError* error;
    
    res = [content writeToFile:[HelpService savePath:fileName]
                              atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!res){
        NSLog(@"%@",error.description);
    }
    
    GSAssert(res);

    
    return res;
}

@end
