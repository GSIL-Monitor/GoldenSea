//
//  HYBaseDBManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/9/18.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYBaseDBManager.h"

@interface HYBaseDBManager ()

@property (strong) NSMutableDictionary* stkdbDict;

@end

@implementation HYBaseDBManager

-(id)init
{
    if(self = [super init]){
        _stkdbDict = [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(NSString*)defaultDBPath
{
    return nil;
}

- (void)setupDB:(NSString*)dbPath isReset:(BOOL)isReset;
{
    
    self.DBHelper = [[HYDatabaseHelper alloc]init];
    [self.DBHelper setupDB:[self defaultDBPath] isReset:isReset];
    
    
    
    self.dbInfo = [[TDBInfo alloc]init];
    [self.dbInfo setup:self.DBHelper];
    if([self.dbInfo createTableWithName:@"tDBInfo"]){
        //        DDLogInfo(@"STK table create success!");
    }else{
        DDLogInfo(@"tDBInfo table create failed!");
    }
    
}


- (BOOL)closeDB
{
    BOOL rst = [self.DBHelper closeDB];
    return rst;
}


-(TKData*)dbserviceWithSymbol:(NSString*)symbol
{
    TKData* dataDBService = [self.stkdbDict safeValueForKey:symbol];
    if(!dataDBService){
        dataDBService = [[TKData alloc]init];
        [dataDBService setup:self.DBHelper];
        [dataDBService createTableWithName:symbol];
        [self.stkdbDict safeSetValue:dataDBService forKey:symbol];
    }
    
    return dataDBService;
}

@end
