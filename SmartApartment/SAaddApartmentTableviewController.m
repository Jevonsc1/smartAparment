//
//  SAaddApartmentTableviewController.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/7.
//  Copyright © 2016年 Trudian. All rights reserved.
//  新增公寓界面

#import "SAaddApartmentTableviewController.h"
#import "BBEmojiCheck.h"

#import "UITextView+Placeholder.h"

#import "SAcreditCardCheckVC.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import <Photos/Photos.h>

//#import "SVProgressHUD.h"

//#import "STPickerArea.h"
//STPickerAreaDelegate

#import "BBImageuploadTool.h"

#import "AFNetworking.h"

//#import "MJExtension.h"

#import "YYModel.h"

@interface SAaddApartmentTableviewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *apartmentName;
@property (weak, nonatomic) IBOutlet UITextField *apartmentAddress;
@property (weak, nonatomic) IBOutlet UITextField *powerMoney;
@property (weak, nonatomic) IBOutlet UITextField *waterMoney;
@property (weak, nonatomic) IBOutlet UITextField *otherMoney;
@property (weak, nonatomic) IBOutlet UITextView *otherMoneyDescription;
@property (weak, nonatomic) IBOutlet UIButton *apartmentPicBtn;
@property (weak, nonatomic) IBOutlet UILabel *addPicBtnLabel;
@property (weak, nonatomic) IBOutlet UITextView *otherMoneyDescriptionView;
@property(nonatomic,strong)UIImage *picImage;

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (nonatomic, strong) UIPickerView    *m_pickerView;
@property (nonatomic, strong) NSMutableArray  *m_yearArray;
@property (nonatomic, strong) NSMutableArray  *m_monthArray;

@property (weak, nonatomic) IBOutlet UIImageView *camImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgKuang;
@property(nonatomic,copy)NSString *stringKey;
@end

@implementation SAaddApartmentTableviewController{
    NSString *fixIDString;
    BOOL hasPic;
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
    self.stringKey = [ModelTool find_UserData].key;
    self.saveBtn.layer.cornerRadius=8;
    hasPic=false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return  236 *ratio;
    }
    if (indexPath.row == 6) {
        return 70 * ratio;
    }
    else{
        return cellHeight;
    }
    
}

//*************************************
//*************************************
//*************************************
//*************************************
//*************************************
//*************************************

- (IBAction)saveApartmentData{
    //下一步上传新公寓信息
    if (!hasPic) {
        [Alert showFail:@"请上传公寓图片" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.apartmentName.text.length==0) {
        [Alert showFail:@"请填写公寓名" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if ([[BBEmojiCheck bbManager] isContainsBBEmoji2:self.apartmentName.text]) {
        [Alert showFail:@"公寓名字不能有表情" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.apartmentAddress.text.length==0) {
        [Alert showFail:@"请填写公寓地址" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if ([[BBEmojiCheck bbManager] isContainsBBEmoji2:self.apartmentAddress.text]) {
        [Alert showFail:@"公寓地址不能有表情" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
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
    
    if ([[BBEmojiCheck bbManager] isContainsBBEmoji2:self.otherMoneyDescription.text]) {
        [Alert showFail:@"费用说明不能有表情" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
//    [SVProgressHUD showWithStatus:@""];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    if (fixIDString.length>0) {
//        [SVProgressHUD dismiss];
        SAcreditCardCheckVC *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"SAcreditCardCheckVC"];
        vc.apartmentNameString=self.apartmentName.text;
        
        vc.apartmentAddressString=[self.placeLabel.text stringByAppendingString:self.apartmentAddress.text];

        vc.apartmentAddressString = [vc.apartmentAddressString stringByReplacingOccurrencesOfString:@" " withString:@""];
        vc.powerMoneyString=self.powerMoney.text;
        vc.waterMoneyString=self.waterMoney.text;
        vc.keyString = [ModelTool find_UserData].key;
        vc.fixIDStringString=fixIDString;
        vc.otherMoneyString=self.otherMoney.text;
        vc.otherMoneyDescriptionString=self.otherMoneyDescription.text;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"communityName"]=self.apartmentName.text;
        params[@"communityAddress"]=self.apartmentAddress.text;
        params[@"communityNodeID"] = nodeID;
        params[@"electricUnitPrice"]=self.powerMoney.text;
        params[@"waterUnitPrice"]=self.waterMoney.text;
        params[@"key"] = [ModelTool find_UserData].key;
        params[@"picAffixs"]=fixIDString;
        params[@"otherChargePrice"]=self.otherMoney.text;
        params[@"otherChargeDesc"]=self.otherMoneyDescription.text;
        params[@"version"] = @"2.0";
        
        [WebAPIForRenthouse creatNewApartment:params callback:^(NSError *err, id response) {
            NSLog(@"[提交公寓信息]%@",response);
            
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue==10000) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //报错
                NSString *string =[response objectForKey:@"rmsg"];
                if (string.length>0) {
                    [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
                }
            }
        }];
//        [self.navigationController pushViewController:vc animated:YES];
    }else{
//        [SVProgressHUD dismiss];
        [Alert showFail:@"图片ID获取失败" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
    }
}

//*************************************
//*************************************
//*************************************
//*************************************
//*************************************
//*************************************

- (IBAction)clickToPop{
    //点击退出
     [self.navigationController popViewControllerAnimated:YES];
}

//*************************************选择地区
//*************************************选择地区
//*************************************选择地区
//*************************************选择地区
//*************************************选择地区
//*************************************选择地区

#pragma mark - 选择地区
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
-(void)setAreaForPickerView{
    
}
//todo
//- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area nodeID:(nonnull NSString *)nodeid
//{
//    if (!nodeid) {
//        nodeID = @"3145";
//    }else {
//        nodeID = nodeid;
//    }
//    
//    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
//    self.placeLabel.text=text;
//    self.placeLabel.textAlignment=NSTextAlignmentLeft;
//}


- (void)requestGetAreaList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];;
    params[@"key"]=[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    [WebAPIForRenthouse getAreaList:params callback:^(NSError *err, id response) {
//todo
//        SAResponse *responseModel =[SAResponse yy_modelWithJSON:response];
//        if (!err && responseModel.rcode==10000) {
//            self.areaArray=response[@"data"][0];
//                        [self.view endEditing:YES];
//            
//            pickerArea = [[STPickerArea alloc]init];
//            [pickerArea setupUI:self.areaArray];
//            
//            [pickerArea setDelegate:self];
//            [pickerArea setContentMode:STPickerContentModeBottom];
//            [pickerArea show];
////
//        }else{
//            [Alert showFail:responseModel.rmsg View:self.navigationController.navigationBar andTime:2 complete:nil];
//        }
        
    }];
}

//*************************************添加公寓图片
//*************************************添加公寓图片
//*************************************添加公寓图片
//*************************************添加公寓图片
//*************************************添加公寓图片
//*************************************添加公寓图片
//*************************************添加公寓图片
//*************************************添加公寓图片

- (IBAction)addPic{
    [self takeBBImage];
    
    __weak typeof(self) weakSelf = self;
    self.returnBBImageBlock=^(UIImage *image){
        typeof(weakSelf) __strong strongSelf = weakSelf;
        [strongSelf uploadBBImage:image];
    };
}

- (void)uploadBBImage:(UIImage *)image{
    //image = [self thumbnailWithImageWithoutScale:image size:self.apartmentPicBtn.size];
    [self.apartmentPicBtn setBackgroundImage:image forState:UIControlStateNormal];
    self.imgKuang.hidden = YES;
    self.camImage.hidden = YES;
    self.addPicBtnLabel.hidden = YES;
    self.apartmentPicBtn.layer.cornerRadius=8;
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
    params[@"key"]=[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    
    
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
    hasPic=true;
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
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}
@end
