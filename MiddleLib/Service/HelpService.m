//
//  HelpService.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/3.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HelpService.h"
#import "HYLog.h"

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


+ (void)log:(NSString *)format, ... {
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        
        message = [NSString stringWithFormat:@"%@\n",message];
 
        printf("%s",[message UTF8String]);
        
        [[HYLog shareManager]logToFile:message];
        
        va_end(args);
    }
}

+(CGFloat)raisingLimitValue:(CGFloat)lastClose
{
    //1.1倍再四舍五入
    CGFloat val = (int)((lastClose*1.1)*100+0.5)/100.f;
    return val;
}


+(BOOL)isRasingLimitValue:(CGFloat)TP1Close T0Close:(CGFloat)T0Close
{
    CGFloat val  = [HelpService raisingLimitValue:TP1Close];
    if(fabsf((val - T0Close)) < 0.01){
        return YES;
    }
    
    return NO;
}

@end
