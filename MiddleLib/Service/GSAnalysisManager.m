//
//  GSFileManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/4/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSAnalysisManager.h"
#import "KDataModel.h"

@interface GSAnalysisManager ()

@property (nonatomic,strong) NSString* currStkUUID;
@property (nonatomic,strong) NSString* currStkFilePath;
@property (nonatomic,strong) NSMutableArray* contentArray;
//@property (nonatomic,strong) NSMutableArray* parseArray;

@end


@implementation GSAnalysisManager

SINGLETON_GENERATOR(GSAnalysisManager, shareManager);



-(void)analysis:(NSString*)stkUUID inDir:(NSString*)docsDir
{
    //reset content when every time read file.
    [self reset];
    
    self.currStkUUID = stkUUID;
    
    [self findSourceFileWithStkUUID:stkUUID inDir:docsDir];
    [self getStkContentArray];
}


-(void)reset
{
    self.currStkUUID = nil;
    self.currStkFilePath = nil;
    self.contentArray = [NSMutableArray array];
//    self.parseArray = [NSMutableArray array];
}


-(NSString*)findSourceFileWithStkUUID:(NSString*)stkUUID inDir:(NSString*)docsDir
{
    
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:docsDir];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([file hasSuffix:@"txt"]) { // || [file hasSuffix:@"xls"]
            //            NSLog(@"file:%@",file);
            //            continue;
            
            NSString* fullPath = [NSString stringWithFormat:@"%@/%@",docsDir,file];
            if([file containsString:stkUUID]){
                self.currStkFilePath = fullPath; //tbd, why servel times?
                return fullPath;
            }
        }
    }
    
    return nil;
    
}


-(NSString*)readFileContent:(NSString*)filePath
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGBK_95);

//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    NSError* error;
    NSString* content = [NSString stringWithContentsOfFile:filePath encoding:enc error:&error];
    
//    NSData* data = [[NSFileManager defaultManager] contentsAtPath:filePath];
//    content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;

    
    return content;
}


-(void)getStkContentArray
{
    
    if(!self.currStkFilePath || ![self.currStkFilePath containsString:self.currStkUUID]){
        GSAssert(NO);
        return;
    }
    
    NSLog(@"getStkContentArray:%@",self.currStkFilePath);
    
    long index = 0;
    long lineIndex = 0;
    
    KDataModel* kData;
    NSString* txt = [self readFileContent:self.currStkFilePath] ;
    if(!txt){
        return;
    }
    
    NSArray *lines = [txt componentsSeparatedByString:@"\n"];
    for(NSString* oneline in lines){
        
//        NSLog(@"oneline:%@",oneline);
        
        //skip addtional info
        lineIndex++;
        if(lineIndex <= 2 ){
            continue;
        }

        NSArray* tmpArray = [oneline componentsSeparatedByString:@"\t"] ;
        if([tmpArray count] != 7){
            continue;
        }
        
//        NSLog(@"oneline:%@",oneline);

        
        //deal with real data.
        kData = [[KDataModel alloc]init];
        [self.contentArray addObject:kData];

        for(long i = 0; i<[tmpArray count] ; i++){
            NSString* value = [tmpArray safeObjectAtIndex:i];
            if(!value){
                continue;
            }
            
            switch (i) {
                case 0:
                    kData.time = value;
                    break;
                    
                case 1:
                    kData.open = [value floatValue];
                    break;
                    
                case 2:
                    kData.high = [value floatValue];
                    break;
                    
                case 3:
                    kData.low = [value floatValue];
                    break;
                    
                case 4:
                    kData.close = [value floatValue];
                    break;
                    
                case 5:
                    kData.volume = [value intValue];
                    break;
                    
                case 6:
                    //no use.
                    break;

                    
                default:
                    break;
            }
        }
        
        index++; //just for debug.
    }
    
}


@end
