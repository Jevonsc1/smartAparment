//
//  WebAPIForMyDoorCard.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/6.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "WebAPIForMyDoorCard.h"
#import "HTTPRequest.h"

@implementation WebAPIForMyDoorCard

+ (NSString *)urlString:(NSString *)subUrl {
    if ([[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] hasSuffix:@"_T"]) {
        return [NSString stringWithFormat:@"%@%@", TEST_API, subUrl];
    }else {
        return [NSString stringWithFormat:@"%@%@", FORMAT_API, subUrl];
    }
}

/**
 门卡信息，包括手机、IC卡、身份证
 */
+ (void)loadDoorCardStateInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/ac_card/getRenterACOptStatusInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

/**
 IC卡信息
 */
+ (void)loadICCardStateInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/ac_card/cardStatus"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

/**
 自助发卡
 */
+ (void)applyICCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/ac_card/applyCard"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

/**
 检验自助发卡结果
 */
+ (void)checkApplyICCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/ac_card/checkApplyCard"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)reportLossICCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/ac_card/reportLoss"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)cancelReportLossICCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/ac_card/cancelReportLoss"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+(void)getRenterACOptStatusInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/ac_card/getRenterACOptStatusInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

@end
