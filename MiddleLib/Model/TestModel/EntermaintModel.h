//
//  EntermaintModel.h
//  iRCS
//
//  Created by frank weng on 15/9/6.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import "HYBaseModel.h"

@interface EntermaintModel : HYBaseModel

@property (nonatomic, strong) NSString* image_url;
@property (nonatomic, strong) NSString * content;
@property (assign) NSInteger id; //such as. entertainment
@property (assign) NSInteger entertainment; //such as.
@end
