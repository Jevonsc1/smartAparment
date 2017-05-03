//
//  BBImageuploadTool.h
//  SmartApartment
//
//  Created by bbapplepen on 2016/11/20.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UploadBBImageBlock)(NSProgress *uploadProgress,NSError *error,id responsedata);

@interface BBImageuploadTool : NSObject

+ (void)uploadBBImage:(UIImage*)bbImage urlString:(NSString *)urlString params:(NSMutableDictionary *)params response:(UploadBBImageBlock)bbImageBlock;

@end
