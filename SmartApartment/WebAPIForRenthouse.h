//
//  WebAPIForRenthouse.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/7.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebAPIForRenthouse : NSObject
//请求公寓列表
+(void)requestApartmentList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//创建新的公寓
+(void)creatNewApartment:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//编辑公寓信息
+(void)editApartment:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//删除公寓
+(void)deleteApartment:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取公寓下的房间列表
+(void)getCommunityHouseList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//创建出租屋房间
+(void)creatRenthouse:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取房屋信息
+(void)getHouseInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//删除房间
+(void)deleteHouse:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//提现
+(void)takeMoneyOut:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//上传开门记录
+(void)uploadACLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取城市列表
+(void)getAreaList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取公寓未支付订单
+(void)getCommunityNoPayOrder:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//编辑用户基本信息(上传头像)
+(void)editMemberInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取租客信息
+(void)getRenterInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
@end
