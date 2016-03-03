//
//  HYBaseRequest.h
//  iRCS
//
//  Created by frank weng on 15/8/25.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import "YTKRequest.h"
#import "HYBaseResponse.h"

@protocol HYbaseRequestDelegate <NSObject>

@required


@end

@interface HYBaseRequest : YTKRequest

@property (nonatomic,weak) id child;
@property (nonatomic,strong) NSMutableDictionary *paramDic;


- (id)initWithUrl:(NSString *)url;


- (void)startWithSuccess:(void (^)(HYBaseRequest *request, HYBaseResponse* response))success
                                    failure:(void (^)(HYBaseRequest *request, HYBaseResponse* response))failure;

//user YYModel to Parse the JsonData
//-(void)startMomentRequestWithSuccess:(void (^)(HYBaseRequest *request, HYBaseResponse *response))success failure:(void (^)(HYBaseRequest *request, HYBaseResponse *response))failure;

@end
