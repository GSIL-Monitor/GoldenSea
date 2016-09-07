//
//  HYLog.m
//  iRCS
//
//  Created by frank weng on 15/11/12.
//  Copyright © 2015年 frank weng. All rights reserved.
//

#import "HYLog.h"

@interface HYLog()
@property (nonatomic,strong) NSString* logFilePath;
@property (assign) BOOL isEnableLog;
@end


@implementation HYLog

SINGLETON_GENERATOR(HYLog, shareInstance);


-(id)init{
    if(self = [super init]){
        [self redirectNSlogToDocumentFolder];
    }
    
    return  self;
}


- (void)redirectNSlogToDocumentFolder
{
    //1,get date
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    NSDate * twoDaysAgoDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec-3600*24*2];

    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
//    [df setDateFormat:@"yyyy-MM-dd HH.mm.ss"];
    
    [df setDateFormat:@"yyyy-MM-dd:HH.mm"];

    
    // 前天的日期
    NSString * strTwoDaysAgoDate = [[df stringFromDate:twoDaysAgoDate] substringToIndex:10];
    
    // 今天的日期
    NSString * strNowDateTime = [df stringFromDate:currentDate];
    NSString *strNowDate= [strNowDateTime substringToIndex:10];

    
/// 2,set output file
    // 获取沙盒Document路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    documentDirectory = @"/Users/frankweng/Code/1HelpCode/GSGoldenSea/result";
    
    // 文件句柄
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
//    // 移除前天的log信息
//     NSError *err=nil;
//    NSString *strTwoDaysAgoDatePath = [NSString stringWithFormat:@"%@/%@", documentDirectory, strTwoDaysAgoDate];
//    if ([fileManager fileExistsAtPath:strTwoDaysAgoDatePath]) {
//        [fileManager removeItemAtPath:strTwoDaysAgoDatePath error:&err];
//        if (err) {
//        }
//        err=nil;
//    }
//    
//    // 创建log目录，用于存放当天所有的log文件
//    NSString *strNowDatePath = [NSString stringWithFormat:@"%@/%@", documentDirectory, strNowDate];
//    if (![fileManager fileExistsAtPath:strNowDatePath]) {
//        [fileManager createDirectoryAtPath:strNowDatePath withIntermediateDirectories:NO attributes:nil error:&err];
//        if (err) {
//        }
//    }
    
    
    NSString *fileName = [NSString stringWithFormat:@"%@.txt",strNowDateTime];
    
    _logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // if had, remove firstly (impossible)
    [fileManager removeItemAtPath:_logFilePath error:nil];
    
    
}

- (void) enableLog
{
//#ifndef DEBUG

    _isEnableLog = YES;
    
//#endif
}

- (void) disableLog;
{
    _isEnableLog = NO;
}

-(BOOL)logToFile:(NSString*)msg
{
    if(!_isEnableLog){
        return  NO;
    }
    
    return [self appendToFile:self.logFilePath msg:msg encoding:NSUTF8StringEncoding];
}


- (BOOL) appendToFile:(NSString *)path msg:(NSString*)msg encoding:(NSStringEncoding)enc;
{
    BOOL result = YES;
    NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:path];
    if ( !fh ) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        fh = [NSFileHandle fileHandleForWritingAtPath:path];
    }
    if ( !fh ) return NO;
    @try {
        [fh seekToEndOfFile];
        [fh writeData:[msg dataUsingEncoding:enc]];
    }
    @catch (NSException * e) {
        result = NO;
    }
    [fh closeFile];
    return result;
}


+ (void) logObject:(NSObject*)obj
{
    unsigned int outCount, i;
    DDLogInfo(@"logObject: %@", [obj class]);
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        
        id value = [obj valueForKey:key];
        DDLogInfo(@"key:%@, value:%@",key,value);
    }
    
    free(properties);
    
    DDLogInfo(@"end of logObject: %@", [obj class]);

}

@end
