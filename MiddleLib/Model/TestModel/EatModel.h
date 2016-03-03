//
//  EatModel.h
//  iRCS
//
//  Created by frank weng on 15/8/27.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import "HYBaseModel.h"


@interface EatChild : NSObject

@end


@interface EatModel : HYBaseModel

@property (nonatomic, strong) NSString* theTitle;
@property (nonatomic, strong) NSArray* entertainment_info;
//@property (nonatomic, strong) NSString * cover_image;
@property (assign) BOOL hasCoverImage;
@property (assign) NSInteger vote_count;
@property (assign) NSUInteger vote_count2;
@property (assign) unsigned long vote_count3; 
@property (nonatomic, strong) EatChild* child;
@property (assign) BOOL bTest;
@end
