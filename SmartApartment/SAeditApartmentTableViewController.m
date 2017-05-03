//
//  SAeditApartmentTableViewController.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/8.
//  Copyright © 2016年 Trudian. All rights reserved.
//  编辑公寓界面

#import "SAeditApartmentTableViewController.h"

//#import "MJExtension.h"

#import "AFNetworking.h"

#import "UIButton+WebCache.h"

//#import "SVProgressHUD.h"

#import "BBImageuploadTool.h"

#import "AFNetworking.h"

#import "YYModel.h"
//#import "STPickerArea.h"
//STPickerAreaDelegate
@interface SAeditApartmentTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *apartmentImage;

@property (weak, nonatomic) IBOutlet UITextField *apartmentName;

@property (weak, nonatomic) IBOutlet UITextField *apartmentAddress;

@property (weak, nonatomic) IBOutlet UITextField *powerMoney;

@property (weak, nonatomic) IBOutlet UITextField *waterMoney;

@property (weak, nonatomic) IBOutlet UITextField *otherMoney;

@property (weak, nonatomic) IBOutlet UITextView *otherMoneyDescription;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property(nonatomic,strong)UIImage *bbImage;

@property(nonatomic,copy)NSString *stringKey;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgKuang;

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic, strong) UIPickerView    *m_pickerView;
@end

@implementation SAeditApartmentTableViewController{
    NSString *fixIDString;
    BOOL hasNewPic;
    
//    STPickerArea *pickerArea;
    //省
    NSMutableArray *cityArr;
    //市
    NSMutableArray *placeArr;
    //区
    NSMutableArray *areaArr;
    UIPickerView *areaPicker;
    NSString *nodeID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hasNewPic=false;
    self.saveBtn.layer.cornerRadius=8;
    self.stringKey =[ModelTool find_UserData].key;
    if (self.apartmentPicArray.count>0) {
        NSString *urlString = self.apartmentPicArray[0];
        [self.apartmentImage sd_setBackgroundImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal];
    }
    
    self.apartmentName.text=self.apartmentNameString;
    self.apartmentAddress.text=self.apartmentAddressString;
    self.powerMoney.text=self.powerMoneyString;
    self.waterMoney.text=self.waterMoneyString;
    self.otherMoney.text=self.otherMoneyString;
    self.otherMoneyDescription.text=self.otherMoneyDescriptionString;
    self.placeLabel.text= self.communityCity;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 230 *ratio;
    }else{
    return cellHeight;
    }
}
//*****************************保存更新
//*****************************退出
//*****************************退出
//*****************************退出
//*****************************退出
//*****************************退出

#pragma mark - 保存更改
- (IBAction)saveEdit:(id)sender {
    [self requestUpdate];
}

//*****************************退出
//*****************************退出
//*****************************退出
//*****************************退出
//*****************************退出
//*****************************退出

- (void)requestUpdate{
    if (self.apartmentName.text.length==0) {
        [Alert showFail:@"请填写公寓名" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.apartmentAddress.text.length==0) {
        [Alert showFail:@"请填写公寓地址" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.powerMoney.text.length==0) {
        [Alert showFail:@"请填写电费" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.waterMoney.text.length==0) {
        [Alert showFail:@"请填写水费" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (hasNewPic) {
        if (fixIDString.length==0) {
            [Alert showFail:@"图片ID获取失败" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
            return;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"communityID"]=self.apartmentID;
    params[@"communityName"]=self.apartmentName.text;
    params[@"communityAddress"]=self.apartmentAddress.text;
    params[@"electricUnitPrice"]=self.powerMoney.text;
    params[@"waterUnitPrice"]=self.waterMoney.text;
    params[@"key"]=[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    params[@"communityNodeID"] = nodeID;
    if (fixIDString.length>0) {
        params[@"picAffixs"]=fixIDString;
    }else{
        params[@"picAffixs"]=@"";
    }
    
    params[@"otherChargePrice"]=self.otherMoney.text;
    params[@"otherChargeDesc"]=self.otherMoneyDescription.text;
    
    [WebAPIForRenthouse editApartment:params callback:^(NSError *err, id response) {
//todo
//        SAResponse *responseModel =[SAResponse yy_modelWithJSON:response];
//        if (!err && responseModel.rcode==10000) {
//            [SVProgressHUD dismiss];
//            [Alert showFail:@"编辑成功！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
//                 [self.navigationController popViewControllerAnimated:YES];
//            }];
//        }else{
//            //报错
//            NSString *string =[response objectForKey:@"rmsg"];
//            if (string.length>0) {
//                [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//            }
//            [SVProgressHUD dismiss];
//        }
    }];

}

//*****************************退出
//*****************************退出
//*****************************退出
//*****************************退出
//*****************************退出
//*****************************退出

- (IBAction)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

//*****************************更改图片
//*****************************更改图片
//*****************************更改图片
//*****************************更改图片
//*****************************更改图片
//*****************************更改图片

#pragma mark - 更换图片
- (IBAction)changePic:(id)sender{
    [self takeBBImage];
    
    __weak typeof(self) weakSelf = self;
    self.returnBBImageBlock=^(UIImage *image){
        typeof(weakSelf) __strong strongSelf = weakSelf;
        //strongSelf.bbImage=image;
        [strongSelf uploadBBImage:image];
        //hasNewPic=true;
    };
}

- (void)uploadBBImage:(UIImage *)image{
    NSLog(@"[currentThread]%@",[NSThread currentThread]);
    //image = [self thumbnailWithImageWithoutScale:image size:self.apartmentImage.size];
    self.addLabel.hidden = YES;
    self.imgKuang.hidden = YES;
    [self.apartmentImage setBackgroundImage:image forState:UIControlStateNormal];
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
    params[@"key"]=self.stringKey;
    
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
//        SAResponse *responseModel =[SAResponse yy_modelWithJSON:responseObject];
//        if (responseModel.rcode==10000) {
//            NSLog(@"[responseObject]%@",responseObject);
//            NSNumber *fixId= responseObject[@"data"][@"affix_id"];
//            fixIDString = [NSString stringWithFormat:@"%@",fixId];
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

- (void)requestGetAreaList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];;
    params[@"key"]=[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    [WebAPIForRenthouse getAreaList:params callback:^(NSError *err, id response) {
//todo
//        SAResponse *responseModel =[SAResponse yy_modelWithJSON:response];
//        if (!err && responseModel.rcode==10000) {
//            self.areaArray=response[@"data"][0];
//            [self.view endEditing:YES];
//            
//            pickerArea = [[STPickerArea alloc]init];
//            [pickerArea setupUI:self.areaArray];
//            
//            [pickerArea setDelegate:self];
//            [pickerArea setContentMode:STPickerContentModeBottom];
//            [pickerArea show];
//            //
//        }else{
//            [Alert showFail:responseModel.rmsg View:self.navigationController.navigationBar andTime:2 complete:nil];
//        }
        
    }];
}


- (IBAction)choosePlace:(id)sender {
    
    if (self.areaArray.count>0) {
        [self.view endEditing:YES];
//todo
//        pickerArea = [[STPickerArea alloc]init];
//        [pickerArea setupUI:self.areaArray];
//        
//        [pickerArea setDelegate:self];
//        [pickerArea setContentMode:STPickerContentModeBottom];
//        [pickerArea show];
    }else{
        [self requestGetAreaList];
    }
    
}

//todo
//- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area nodeID:(nonnull NSString *)nodeid
//{
// 
//    nodeID = nodeid;
//    NSLog(@"编辑的nodeid---%@",nodeid);
//    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
//    self.placeLabel.text=text;
//    self.placeLabel.textAlignment=NSTextAlignmentLeft;
//}
//- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
//{
//    UIImage *newimage;
//    if (nil == image) {
//        newimage = nil;
//    }
//    else{
//        CGSize oldsize = image.size;
//        CGRect rect;
//        if (asize.width/asize.height > oldsize.width/oldsize.height) {
//            rect.size.width = asize.height*oldsize.width/oldsize.height;
//            rect.size.height = asize.height;
//            rect.origin.x = (asize.width - rect.size.width)/2;
//            rect.origin.y = 0;
//        }
//        else{
//            rect.size.width = asize.width;
//            rect.size.height = asize.width*oldsize.height/oldsize.width;
//            rect.origin.x = 0;
//            rect.origin.y = (asize.height - rect.size.height)/2;
//        }
//        UIGraphicsBeginImageContext(asize);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
//        [image drawInRect:rect];
//        newimage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    return newimage;
//}
@end
