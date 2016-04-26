//
//  HYBaseRequest.m
//  iRCS
//
//  Created by frank weng on 15/8/25.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import "HYBaseRequest.h"
#import "HYBaseResponse.h"
#import "HYRequestManager.h"
//#import "NSObject+YYModel.h"

@interface HYBaseRequest()

@property (nonatomic) NSString* apiURL;

@end


@implementation HYBaseRequest


-(id)init
{
    self = [super init];
    if(self){
        if([self conformsToProtocol:@protocol(HYbaseRequestDelegate)]){
            self.child = self;
        }else{
//            NSAssert(NO, @"child class must implement the HYbaseRequestDelegate");
        }
        
        self.paramDic = [NSMutableDictionary dictionary];
    }
    
    return self;
}


- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if(self){
        if([self conformsToProtocol:@protocol(HYbaseRequestDelegate) ]){
            self.child = self;
        }else{
//            NSAssert(NO, @"child class must implement the HYbaseRequestDelegate");
        }
        
        self.paramDic = [NSMutableDictionary dictionary];
        _apiURL = url;
    }
    
    return self;
}


-(void)dealloc
{
    [self stop];
}

- (YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (NSString *)requestUrl
{
    //add agent.
    
    if([[_apiURL lowercaseString] hasPrefix:@"http:"] || [[_apiURL lowercaseString] hasPrefix:@"https:"] ){
        return _apiURL;
    }
    
//    NSLog(@"full url path: %@", [NSString stringWithFormat:@"%@%@",Server_BaseURL,_apiURL]);
    return [NSString stringWithFormat:@"%@%@",Server_BaseURL,_apiURL];
}

-(id) rawData
{
    return self.responseJSONObject;
}


-(NSDictionary *)requestHeaderFieldValueDictionary{
    return @{@"User-Agent":@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36", @"Cookie":@"s=2xjv17wxca; bid=980a0ffa0c20398f8c5102d22f7c0733_ijf71lzw; webp=1; xq_a_token=f7f850c8cd3ad9bf4d15ed05a15d24d7c813a8e9; xqat=f7f850c8cd3ad9bf4d15ed05a15d24d7c813a8e9; xq_r_token=e09045bf8c0808a3c3aa92b0740f56428512523b; xq_is_login=1; u=9036714866; xq_token_expire=Thu%20Mar%2010%202016%2012%3A26%3A09%20GMT%2B0800%20(CST); Hm_lvt_1db88642e346389874251b5a1eded6e3=1456490293,1457108445,1457140447,1457141400; Hm_lpvt_1db88642e346389874251b5a1eded6e3=1457141400; __utmt=1; __utma=1.852695814.1452832627.1457108442.1457138663.28; __utmb=1.9.10.1457138663; __utmc=1; __utmz=1.1452832627.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)"
             };
}

-(id) responseDataFromObj:(id)responseObj
{
    HYBaseResponse* response = [[HYBaseResponse alloc]init];
    
    NSDictionary* dict = (NSDictionary*)responseObj;
    response.errorCode = [[dict valueForKey:@"code"] integerValue];
    if(!response.errorCode){
        response.data = [[NSClassFromString([HYRequestManager modelWithRequst:NSStringFromClass([self class])]) alloc] initFromObj:responseObj];
    }
    
    response.respError = [dict valueForKey:@"message"] ;

    
    return response;
}

//use YYModel to parse the JsonData
//- (id) responseDataWithYYModelFromObj:(id)responseObj
//{
//    HYBaseResponse* response = [[HYBaseResponse alloc]init];
//    
//    NSDictionary* dict = (NSDictionary*)responseObj;
//    response.errorCode = [[dict safeValueForKey:@"code"] integerValue];
//    if(!response.errorCode){
//        response.data = [NSClassFromString([HYRequestManager modelWithRequst:NSStringFromClass([self class])]) modelWithJSON:responseObj];
//    }
//    response.respError = [dict safeValueForKey:@"message"] ;
//    return response;
//}


#pragma mark - interface func
-(void)startWithSuccess:(void (^)(HYBaseRequest *request, HYBaseResponse *response))success failure:(void (^)(HYBaseRequest *request, HYBaseResponse *response))failure
{
    WS(tws);
    [self startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        HYBaseResponse* response = [tws responseDataFromObj:request.responseJSONObject];
        success(tws,response);

        //to future.
//        if(!response.errorCode){
//            success(tws,response);
//        }else{
//            failure(tws,response);
//        }
    } failure:^(YTKBaseRequest *request) {
        failure(tws,[tws responseDataFromObj:request.responseJSONObject]);
    }];
}

//-(void)startMomentRequestWithSuccess:(void (^)(HYBaseRequest *request, HYBaseResponse *response))success failure:(void (^)(HYBaseRequest *request, HYBaseResponse *response))failure
//{
//    WS(tws);
//    [self startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        HYBaseResponse* response = [tws responseDataWithYYModelFromObj:request.responseJSONObject];
//        success(tws,response);
//    } failure:^(YTKBaseRequest *request) {
//        HYBaseResponse* response = [tws responseDataWithYYModelFromObj:request.responseJSONObject];
//        failure(tws,response);
//    }];
//
//}


#pragma mark - override the YTKBaseRequest  func
-(id)jsonValidator
{
    return  [super jsonValidator];
}

-(BOOL)statusCodeValidator
{
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) { //fix me
        return YES;
    } else {
        return NO;
    }
}

@end
