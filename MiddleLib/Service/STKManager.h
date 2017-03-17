//
//  STKManager.h
//  GSGoldenSea
//
//  Created by frank weng on 16/3/4.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKModel.h"

@interface STKManager : NSObject

+(STKManager*)shareInstance;

-(void)saveStkToDB;


@end
