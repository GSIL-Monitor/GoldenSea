//
//  STKxlsReader.h
//  testXls
//
//  Created by frank weng on 16/10/18.
//  Copyright © 2016年 frank weng. All rights reserved.
//


@interface STKxlsReader : NSObject

+(STKxlsReader*)shareInstance;


- (void)startWithPath:(NSString *)xlsPath dbPath:(NSString*)dbPath;


@end
