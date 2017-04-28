//
//  WebAPIForBroadband.h
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/27.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebAPIForBroadband : NSObject

+ (void)loadTelecomOrderInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)loadTelecomOrderInfoDetail:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)loadTelecomInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)loadTelecomInfoDetail:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)loadHistoryOrderInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)loadHistoryOrderInfoDetail:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)submitApplyTelecom:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)submitTelecomPassword:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)telecomMakeAnAppointment:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)telecomCancelTheAppointment:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)loadHostAdvInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
@end
