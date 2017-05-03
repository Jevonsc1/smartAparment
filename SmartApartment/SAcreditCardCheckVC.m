//
//  SAcreditCardCheckVC.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/8.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SAcreditCardCheckVC.h"

//#import "MJExtension.h"

#import "AFNetworking.h"

@interface SAcreditCardCheckVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property(nonatomic,strong)NSMutableDictionary *paramsdict;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn1;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn2;
@property(nonatomic,strong)NSMutableArray *houseIDStringArray;
@property(nonatomic,strong)UIImage *picImage;
@property(nonatomic,strong)UIImage *picImage2;
@property(nonatomic,copy)NSString *stringKey;
@end

@implementation SAcreditCardCheckVC{
    int btnTag;
    NSString *houseidString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius=8;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"communityName"]=self.apartmentNameString;
    params[@"communityAddress"]=self.apartmentAddressString;
    params[@"electricUnitPrice"]=self.powerMoneyString;
    params[@"waterUnitPrice"]=self.waterMoneyString;
    params[@"key"]=self.keyString;
    params[@"picAffixs"]=self.fixIDStringString;
    params[@"otherChargePrice"]=self.otherMoneyString;
    params[@"otherChargeDesc"]=self.otherMoneyDescriptionString;
    self.paramsdict=params;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choosePic1:(id)sender{
    [self takeBBImage];
    
    __weak typeof(self) weakSelf = self;
    self.returnBBImageBlock=^(UIImage *image){
        typeof(weakSelf) __strong strongSelf = weakSelf;
        strongSelf.picImage=image;
        [strongSelf.chooseBtn1 setBackgroundImage:image forState:UIControlStateNormal];
        strongSelf.chooseBtn1.layer.cornerRadius=8;
    };
}

- (IBAction)choosePic2:(id)sender{
    [self takeBBImage];
    __weak typeof(self) weakSelf = self;
    self.returnBBImageBlock=^(UIImage *image){
        typeof(weakSelf) __strong strongSelf = weakSelf;
        strongSelf.picImage2=image;
        [strongSelf.chooseBtn2 setBackgroundImage:image forState:UIControlStateNormal];
        strongSelf.chooseBtn2.layer.cornerRadius=8;
    };
}

- (void)uploadBBImage:(UIImage *)image{
    NSLog(@"[currentThread]%@",[NSThread currentThread]);
    
    //上传图片：参数1
    NSString *urlString = nil;
    if ([[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] hasSuffix:@"_T"]) {
        urlString = TEST_UPLOAD_API;
    }else {
        urlString = FORMAT_UPLOAD_API;
    }
    
    //上传图片：params参数：filename
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    //上传图片：params参数：fileType
    NSData *imageData =UIImageJPEGRepresentation(image,0.5);
    NSString *fileType = [self contentTypeForImageData:imageData];
    //上传图片：params参数：imgData
    NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileName"]=fileName;
    params[@"fileType"]=fileType;
    params[@"imgData"]=imageString;
    params[@"key"]=self.keyString;
    
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
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//todo
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:responseObject];
//        if (responseModel.rcode==10000) {
//            NSLog(@"[responseObject]%@",responseObject);
//            NSNumber *fixId= responseObject[@"data"][@"affix_id"];
//            NSString *string = [NSString stringWithFormat:@"%@",fixId];
//            [self.houseIDStringArray addObject:string];
//        }else{
//            [Alert showFail:responseModel.rmsg View:self.navigationController.navigationBar andTime:2 complete:nil];
//            [SVProgressHUD dismiss];
//        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    //返回图片扩展名
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

#pragma mark - 提交
//提交
- (IBAction)submit:(id)sender {
    
    if (!self.picImage && !self.picImage2) {
        [Alert showFail:@"请上传至少一张图片" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.picImage) {
        [self uploadBBImage:self.picImage];
    }
    
    if (self.picImage2) {
        [self uploadBBImage:self.picImage2];
    }
    
    if (self.houseIDStringArray.count==0) {
        [Alert showFail:@"图片正在上传" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.houseIDStringArray.count==1) {
        NSString *idString =self.houseIDStringArray[0];
        [self.paramsdict setObject:idString forKey:@"certificateAffixs"];
    }
    
    if (self.houseIDStringArray.count==2) {
        NSString *houseIDString = [self.houseIDStringArray componentsJoinedByString:@","];
        [self.paramsdict setObject:houseIDString forKey:@"certificateAffixs"];
    }
    
    if ([self.editApart isEqualToString:@"yes"]) {
        [self.paramsdict removeObjectForKey:@"picAffixs"];
        self.paramsdict[@"communityID"] = self.comID;
        NSLog(@"%@",self.paramsdict);
        [WebAPIForRenthouse editApartment:self.paramsdict callback:^(NSError *err, id response) {
//todo
//            SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//            if (!err && responseModel.rcode==10000) {
//                [Alert showFail:@"已经成功重新提交资质！" View:self.navigationController.navigationBar andTime:3 complete:^(BOOL isComplete) {
//                    [PopHome popToController:@"SAapartmentViewController" andVC:self];
//                }];
//        
//            }else{
//                if (err) {
//                    [Alert showFail:@"网络异常，请检查网络！" View:self.navigationController.navigationBar andTime:3 complete:nil];
//                }else{
//                    NSString *string =[response objectForKey:@"rmsg"];
//                    if (string.length>0) {
//                        [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//                    }
//                }
//            }
        }];
    }else{
        [WebAPIForRenthouse creatNewApartment:self.paramsdict callback:^(NSError *err, id response) {
            NSLog(@"[提交公寓信息]%@",response);
//todo
//            SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//            if (!err && responseModel.rcode==10000) {
//                int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
//                if(index>2){
//                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
//                }else{
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }
//            }else{
//                //报错
//                NSString *string =[response objectForKey:@"rmsg"];
//                if (string.length>0) {
//                    [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//                }
//            }
        }];
    }
}

- (IBAction)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableDictionary *)paramsdict{
    if (_paramsdict==nil) {
        _paramsdict=[NSMutableDictionary dictionary];
    }
    return _paramsdict;
}

- (NSMutableArray *)houseIDStringArray{
    if (_houseIDStringArray == nil) {
        _houseIDStringArray = [NSMutableArray array];
    }
    return _houseIDStringArray;
}

@end
