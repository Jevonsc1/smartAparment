//
//  HTTPRequest.m
//  CarLife
//  Http服务类
//  Created by kenshinhu on 2/24/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "HTTPRequest.h"

@implementation HTTPRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 8.0f;
        //如果报接受类型不一致请替换一致text/html或别的
//        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
        
    }
    return self;
}

-(void)setHeader:(NSDictionary *)header{

    //申明请求的数据是json类型
 
    //如果报接受类型不一致请替换一致text/html或别的
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
 
}

-(void)POST:(NSString *)url body:(NSDictionary *)formData response:(HttpReqestBlock)block{
    
    [manager POST:url parameters:formData progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         block(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        block(error,nil);
    }];
 
}
-(void)POSTProgress:(NSString *)url body:(NSDictionary *)formData response:(ProgressBlock)block{
    [manager POST:url parameters:formData progress:^(NSProgress * _Nonnull uploadProgress) {
        block(nil,nil,uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          block(nil,responseObject,@"100");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
          block(error,nil,@"0");
    }];
    
}

-(void)GET:(NSString *)url query:(NSDictionary *)queryData response:(HttpReqestBlock)block{
    [manager GET:url parameters:queryData progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         block(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        block(error,nil);
    }];

}

-(void)DELETE:(NSString *)url body:(NSDictionary *)formData response:(HttpReqestBlock)block{
    [manager DELETE:url parameters:formData success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         block(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        block(error,nil);
    }];
  
}



@end
