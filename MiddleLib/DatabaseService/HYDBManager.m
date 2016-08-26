//
//  HYDBManager.m
//  HYBaseProject
//
//  Created by frank weng on 16/6/21.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYDBManager.h"
#import "HYDatabaseHelper.h"

#import "TSTK.h"

@interface HYDBManager()

@property (nonatomic, strong) HYDatabaseHelper        *DBHelper;
@property (strong) NSMutableDictionary* stkdbDict;

@end

@implementation HYDBManager

SINGLETON_GENERATOR(HYDBManager, defaultManager)

-(id)init
{
    if(self = [super init]){
        _stkdbDict = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+(NSString*)defaultDBPath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* stkdbdir = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/GSStkDB.db",[paths stringByDeletingLastPathComponent]];
    
    return stkdbdir;
}

- (void)setupDB:(NSString*)dbPath isReset:(BOOL)isReset;
{
    
    
    
    self.DBHelper = [[HYDatabaseHelper alloc]init];
    [self.DBHelper setupDB:[HYDBManager defaultDBPath] isReset:isReset];
   
    
    [[TSTK shareInstance]setup:self.DBHelper];
    if([[TSTK shareInstance]createTableWithName:@"tSTKBasicInfo"]){
//        DDLogInfo(@"STK table create success!");
    }else{
        DDLogInfo(@"STK table create failed!");
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
