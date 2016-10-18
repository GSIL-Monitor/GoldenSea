//
//  STKxlsReader.m
//  testXls
//
//  Created by frank weng on 16/10/18.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STKxlsReader.h"
#import "HYSTKDBManager.h"

/*
 @property (nonatomic, strong) NSString* stkID;
 @property (nonatomic, strong) NSString* name;
 @property (nonatomic, strong) NSString* industry;
 @property (nonatomic, strong) NSString* province;
 @property (nonatomic, assign) CGFloat totalMV; //market value;
 @property (nonatomic, assign) CGFloat curMV; //current market value;
 */

#define ColumnIndex_stkID       1
#define ColumnIndex_name        (ColumnIndex_stkID+1)
#define ColumnIndex_industry    (ColumnIndex_name+1)
#define ColumnIndex_province    (ColumnIndex_industry+1)
#define ColumnIndex_property    (ColumnIndex_province+1)
#define ColumnIndex_totalMV     (ColumnIndex_property+1)
#define ColumnIndex_curPercent  (ColumnIndex_totalMV+1)

#define ColumnIndex_BookValue   (ColumnIndex_curPercent+1)
#define ColumnIndex_PB          (ColumnIndex_bookValue+1)
#define ColumnIndex_title       (ColumnIndex_PB+1)
#define ColumnIndex_level       (ColumnIndex_title+1)

#define ColumnIndex_increase12t15   (ColumnIndex_level+1)
#define ColumnIndex_increase16      (ColumnIndex_increase12t15+1)

#define ColumnIndex_note        (ColumnIndex_increase16+1)
#define ColumnIndex_ref         (ColumnIndex_note+1)



@interface STKxlsReader ()
@property (nonatomic, strong) DHxlsReader* reader;
@end

@implementation STKxlsReader

SINGLETON_GENERATOR(STKxlsReader, shareInstance);


//代码， 名称


- (void)startWithPath:(NSString *)xlsPath dbPath:(NSString*)dbPath;
{
    self.reader = [DHxlsReader xlsReaderWithPath:xlsPath];
    
    
    NSString* text;
    
#if 1
    [self.reader startIterator:0];
    
    while(YES) {
        DHcell *cell = [self.reader nextCell];
        if(cell.type == cellBlank) break;
        
        text = [text stringByAppendingFormat:@"\n%@\n", [cell dump]];
    }
#else
    int row = 2;
    while(YES) {
        DHcell *cell = [reader cellInWorkSheetIndex:0 row:row col:2];
        if(cell.type == cellBlank) break;
        DHcell *cell1 = [reader cellInWorkSheetIndex:0 row:row col:3];
        NSLog(@"\nCell:%@\nCell1:%@\n", [cell dump], [cell1 dump]);
        row++;
        
        //text = [text stringByAppendingFormat:@"\n%@\n", [cell dump]];
        //text = [text stringByAppendingFormat:@"\n%@\n", [cell1 dump]];
    }
#endif
}


-(void)initDB
{
    BOOL isRest = NO;
    [[HYSTKDBManager defaultManager]setupDB:nil isReset:isRest];

}


@end
