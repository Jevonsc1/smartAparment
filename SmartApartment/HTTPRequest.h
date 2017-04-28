//
//  HTTPRequest.h
//  CarLife
//
//  Created by kenshinhu on 2/24/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^HttpReqestBlock)(NSError *error,id response);
typedef void (^ProgressBlock)(NSError *error,id response,id progress);
@interface HTTPRequest : NSObject
{
    AFHTTPSessionManager *manager;
}
@property(nonatomic,strong) NSDictionary* header; //请求头

// HTTP Post请求方法
-(void)POST:(NSString *)url
       body:(NSDictionary*)formData
   response:(HttpReqestBlock)block;
-(void)POSTProgress:(NSString *)url
       body:(NSDictionary*)formData
   response:(ProgressBlock)block;
// HTTP GET 请求方法
-(void)GET:(NSString *)url
     query:(NSDictionary*)queryData
  response:(HttpReqestBlock)block;

//HTTP DELETE请求方法
-(void)DELETE:(NSString *)url
         body:(NSDictionary*)formData
     response:(HttpReqestBlock)block;

@end

