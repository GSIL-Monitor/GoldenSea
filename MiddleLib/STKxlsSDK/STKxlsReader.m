//
//  STKxlsReader.m
//  testXls
//
//  Created by frank weng on 16/10/18.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STKxlsReader.h"

#import "STKModel.h"
#import "HYSTKDBManager.h"
#import "XlsxReaderWriter.h"

/*
 @property (nonatomic, strong) NSString* stkID;
 @property (nonatomic, strong) NSString* name;
 @property (nonatomic, strong) NSString* industry;
 @property (nonatomic, strong) NSString* province;
 @property (nonatomic, assign) CGFloat totalMV; //market value;
 @property (nonatomic, assign) CGFloat curMV; //current market value;
 */

//sheet index
#define SheetIndex_600         (1)
#define SheetIndex_000         (SheetIndex_600+1)
#define SheetIndex_002         (SheetIndex_000+1)
#define SheetIndex_300         (SheetIndex_002+1)


//cloumn index
#define ColumnIndex_stkID       0
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
@property (nonatomic, strong) BRAOfficeDocumentPackage *spreadsheet;
@property (nonatomic, strong) BRAOfficeDocument *workbook;
@end

@implementation STKxlsReader

SINGLETON_GENERATOR(STKxlsReader, shareInstance);

-(id)init
{
    if(self = [super init]){
        [self initDB];
    }
    
    return self;
}


- (void)startWithPath:(NSString *)xlsPath dbPath:(NSString*)dbPath;
{
    _spreadsheet = [BRAOfficeDocumentPackage open:xlsPath];
    _workbook = _spreadsheet.workbook;
    
    [self readDongFangXls];
    
    
    NSLog(@"end of startWithPath");
}

#pragma mark - dongFang xls
-(void)readDongFangXls
{
    BRAWorksheet *worksheet = _workbook.worksheets[0];
    [self readWorkSheet:worksheet base:0];
}


#pragma mark - self xls
- (void)readSelfXls;
{
    NSInteger base=0;
    for(long i=1; i<=4; i++){
        BRAWorksheet *worksheet = _workbook.worksheets[i];
        [self readWorkSheet:worksheet base:i];
    }
    
}

-(void)readWorkSheet:(BRAWorksheet*)worksheet base:(NSInteger)base
{
    for(long i=1; i<[worksheet.rows count]; i++){ //0 is title
        BRARow* row = [worksheet.rows safeObjectAtIndex:i];
        STKModel* stkMod = [[STKModel alloc]init];
        long sid = 0;
        for(long j=ColumnIndex_stkID; j<[row.cells count]; j++){
            BRACell* cell = [row.cells safeObjectAtIndex:j];
            switch (j) {
                case ColumnIndex_stkID:
                    stkMod.stkID = [self convertSTKID:base cell:cell];
                    break;
                    
                case ColumnIndex_name:
                    stkMod.name = cell.stringValue;
                    break;
                    
                case ColumnIndex_industry:
                    stkMod.industry = cell.stringValue;
                    break;
                    
                case ColumnIndex_province:
                    stkMod.province = cell.stringValue;
                    break;
                    
                case ColumnIndex_totalMV:
                    stkMod.totalMV = cell.floatValue;
                    break;
                    
                case ColumnIndex_curPercent:
                    stkMod.curMV = cell.floatValue*stkMod.totalMV;
                    break;
                    
                default:
                    break;
            }
            
        }
        
        if([stkMod.name isValidString]){
            [[HYSTKDBManager defaultManager].allSTK addRecord:stkMod];
        }

    }
}


-(NSString*)convertSTKID:(NSInteger)base cell:(BRACell*)cell
{
    NSString* stkID;
    NSString *prefix = (cell.integerValue>=600000)? @"SH":@"SZ";
    
    switch (base) {
        case 1: //600
        case 4: //300
            stkID = [NSString stringWithFormat:@"%@%ld",prefix,cell.integerValue];
            break;

        case 2: //000
            stkID = [NSString stringWithFormat:@"%@000%ld",prefix,cell.integerValue];
            break;

        case 3: //002
            stkID = [NSString stringWithFormat:@"%@002%ld",prefix,cell.integerValue];
            break;

        default:
            break;
    }
    
    return stkID;
}


-(void)initDB
{
    BOOL isRest = YES;
    [[HYSTKDBManager defaultManager]setupDB:nil isReset:isRest];

}


@end
