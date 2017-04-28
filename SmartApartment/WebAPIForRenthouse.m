//
//  WebAPIForRenthouse.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/7.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "WebAPIForRenthouse.h"
#import "HTTPRequest.h"

@implementation WebAPIForRenthouse

+ (NSString *)urlString:(NSString *)main{
    if ([[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] hasSuffix:@"_T"]) {
        return [NSString stringWithFormat:@"%@%@",TEST_API,main];
    }else {
        return [NSString stringWithFormat:@"%@%@",FORMAT_API,main];
    }
}

#pragma mark -m 获取公寓列表
+(void)requestApartmentList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/getCommunityInfoList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//--------------------------------------出租屋公寓接口-----------------------------------//
#pragma mark -m 创建新的公寓
+(void)creatNewApartment:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/createNewCommunity"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

#pragma mark -m 编辑公寓信息
+(void)editApartment:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/editCommunityInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

#pragma mark -m 删除公寓
+(void)deleteApartment:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/deleteCommunity"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

#pragma mark -m 获取公寓下的房间列表
+(void)getCommunityHouseList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/getCommunityHouseList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//--------------------------------------出租屋房屋接口-----------------------------------//
#pragma mark -m 创建出租屋房间
+(void)creatRenthouse:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/createNewHouse"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

#pragma mark -m 获取房屋信息
+(void)getHouseInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/getHouseInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

#pragma mark -m 删除房间
+(void)deleteHouse:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/deleteHouse"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 提现
+(void)takeMoneyOut:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/withdrawCash"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 上传开门记录
+(void)uploadACLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/access/uploadACLog"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 获取城市列表
+(void)getAreaList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/getAreaList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 获取公寓未支付订单
+(void)getCommunityNoPayOrder:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/getCommunityNoPayOrder"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 编辑用户基本信息(上传头像)
+(void)editMemberInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/member/editMemberInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 获取租客信息
+(void)getRenterInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/renter/getRenterInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

@end
