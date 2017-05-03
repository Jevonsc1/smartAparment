//
//  BBImageuploadTool.m
//  SmartApartment
//
//  Created by bbapplepen on 2016/11/20.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "BBImageuploadTool.h"

#import "AFNetworking.h"

@implementation BBImageuploadTool

+ (void)uploadBBImage:(UIImage*)bbImage urlString:(NSString *)urlString params:(NSMutableDictionary *)params response:(UploadBBImageBlock)bbImageBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        bbImageBlock(uploadProgress,nil,nil);
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        bbImageBlock(nil,nil,responseObject);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        bbImageBlock(nil,error,nil);
    }];
}

@end
