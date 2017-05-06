//
//  WebAPIForMyDoorCard.h
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/6.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebAPIForMyDoorCard : NSObject

+ (void)loadDoorCardStateInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)loadICCardStateInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)applyICCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)checkApplyICCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)reportLossICCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+ (void)cancelReportLossICCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+(void)getRenterACOptStatusInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
@end
