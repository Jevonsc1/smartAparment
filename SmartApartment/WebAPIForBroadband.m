//
//  WebAPIForBroadband.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/27.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "WebAPIForBroadband.h"
#import "HTTPRequest.h"

@implementation WebAPIForBroadband

+ (NSString *)urlString:(NSString *)subUrl {
    if ([[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] hasSuffix:@"_T"]) {
        return [NSString stringWithFormat:@"%@%@", TEST_API, subUrl];
    }else {
        return [NSString stringWithFormat:@"%@%@", FORMAT_API, subUrl];
    }
}

+ (void)loadTelecomOrderInfoDetail:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/getTelecomOrderInfoDetail"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)loadTelecomOrderInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/getLatestTelecomOrderInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)loadTelecomInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/getTelecomInfoList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)loadTelecomInfoDetail:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/getTelecomInfoDetail"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)loadHistoryOrderInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/getTelecomOrderInfoList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)loadHistoryOrderInfoDetail:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/getTelecomOrderInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)submitApplyTelecom:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/applyTelecom"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)submitTelecomPassword:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/setTelecomAccountPassword"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)telecomMakeAnAppointment:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/bookingTelecom"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)telecomCancelTheAppointment:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/cancelBookingTelecom"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+ (void)loadHostAdvInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback {
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/advertise/getHostAdvInfoList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
@end
