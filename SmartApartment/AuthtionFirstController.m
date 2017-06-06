//
//  AuthtionFirstController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/24.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AuthtionFirstController.h"
#import "AuthtionSeconController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HWCloudsdk.h"
#import "AuthtionResultController.h"
#import "UIImage+fixOrientation.h"
@interface AuthtionFirstController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *forwardIDImg;
@property (weak, nonatomic) IBOutlet UIView *forwardClickView;
@property (weak, nonatomic) IBOutlet UIView *backClickView;
@property (weak, nonatomic) IBOutlet UIImageView *backIDImg;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation AuthtionFirstController
{
     UIImagePickerController *_imagePickerController;
    //判断是否正面照
    BOOL isForwardImage;
    //正面照的数据
    NSData *forwardData;
    //背面照的数据
    NSData *backData;
    //图片类型
    NSString *imageType;
    //图片名
    NSString *oneImageName;
    NSString *twoImageName;
    //判断是否已经拍照
    BOOL hadForwardImg;
    BOOL hadBackImg;
    //汉王SDK
    HWCloudsdk *sdk;
    BOOL hadHanvonForward;
    BOOL hadHanvonBack;
    //判断是否识别出正确的身份证
    BOOL isRightIDCard;
    //用户名和身份证号
    NSString *idName;
    NSString *idNumber;
    NSString *backMsg;
    //错误码和错误信息
    NSString *errCode;
    NSString *errMsg;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"实名认证"];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue,^{
        //异步初始化照相机
          [self initImagePicker];
    });
  
    [self initClickTap];
    sdk = [[HWCloudsdk alloc] init];
    hadBackImg = NO;
    hadForwardImg = NO;
    hadHanvonBack = NO;
    hadHanvonForward = NO;
    isRightIDCard = NO;
    if (self.frontImage != nil && self.backImage != nil) {
        hadBackImg = YES;
        hadForwardImg = YES;
        [self.forwardIDImg setImage: self.frontImage];
        [self.backIDImg setImage:self.backImage];
        forwardData = UIImageJPEGRepresentation(self.forwardIDImg.image, 0.3);
        backData = UIImageJPEGRepresentation(self.backIDImg.image, 0.3);
        imageType = @"jpg";
        oneImageName = @"forward.jpg";
        twoImageName = @"back.jpg";
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    if ([self.wayIn isEqualToString:@"SignRoom"]) {
        self.title = @"身份证拍照";
        [self.nextBtn setTitle:@"确认" forState:UIControlStateNormal];
    }
    else
    {
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
/**
 创建两个单击手机，点击弹出照相机
 */
-(void)initClickTap{
    //创建正面照的单击手势
    UITapGestureRecognizer *forwardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePictureForward)];
    [self.forwardClickView addGestureRecognizer:forwardTap];
    //创建背面照的单击手势
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePictureBack)];
    [self.backClickView addGestureRecognizer:backTap];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)takePictureForward{
    [self selectImageFromCamera];
    isForwardImage = YES;
}
-(void)takePictureBack{
    [self selectImageFromCamera];
    isForwardImage = NO;
}


/**
 点击下一步，向汉王接口请求，获得身份证信息

 */
- (IBAction)clickToHanvon:(id)sender {
    if ([self.wayIn isEqualToString:@"SignRoom"]) {
        [self uploadImage];
        return;
    }
    if ( hadHanvonForward) {
        if (hadBackImg&&hadForwardImg) {
            //如果不是正确的身份证，跳转到错误界面
            if (!isRightIDCard) {
                AuthtionResultController *vc =[[UIStoryboard storyboardWithName:@"IDAuthtion" bundle: nil] instantiateViewControllerWithIdentifier:@"AuthtionResultController"];
                vc.resultType = 2;
                vc.errMsg = errMsg;
                vc.errCode = errCode;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                //上传身份证照片，跳转到第二步手持身份证界面
                [self uploadImage];
            }
        }else{
            if (!hadForwardImg) {
                [Alert showFail:@"请拍摄身份证正面照!" View:self.view andTime:1.5f complete:nil];
            }else if (!hadBackImg){
                [Alert showFail:@"请拍摄身份证背面照!" View:self.view
                        andTime:1.5 complete:nil];
            }
        }
        
    }else{
        [Alert showFail:@"请等待身份证识别!" View:self.view andTime:1.5 complete:nil];
    }
}

/**
 初始化照相机
 */
-(void)initImagePicker{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = NO;
}
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    _imagePickerController.videoQuality = UIImagePickerControllerQualityType640x480;
    
    //设置摄像头模式 为拍照模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}


//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
     NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        imageType = @"jpg";
        oneImageName = @"forward.jpg";
        twoImageName = @"back.jpg";
    }else{
        imageType = @"png";
        oneImageName = @"forward.png";
        twoImageName = @"back.png";
    }
  
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //判断是正面还是反面照
        if (isForwardImage) {
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            image = [image fixOrientation];
            self.forwardIDImg.image =image;
            //压缩图片---用于上传到服务器的图片数据
            forwardData = UIImageJPEGRepresentation(self.forwardIDImg.image, 0.3);
            hadForwardImg = YES;
            if (![self.wayIn isEqualToString:@"SignRoom"]) {
                
            
            dispatch_group_t group =  dispatch_group_create();
            
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               
                [self authtionIDCardImage];
            });
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                hadHanvonForward = YES;
                if (isRightIDCard) {
                    [Alert showFail:@"识别身份证成功！" View:self.view andTime:1.5 complete:nil];
                }else{
                    [Alert showFail:@"识别身份证失败！" View:self.view andTime:1.5 complete:nil];
                }
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            }
        }else{
            self.backIDImg.image =[info[UIImagePickerControllerOriginalImage] fixOrientation];
;
            //压缩图片---用于上传到服务器的图片数据
            backData = UIImageJPEGRepresentation(self.backIDImg.image, 0.3);
            hadBackImg = YES;
          
        }
        
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 上传图片到服务器
 */
-(void)uploadImage{
    NSArray *imageArr = @[self.forwardIDImg.image,self.backIDImg.image];
    NSMutableArray *imageIDArr = [NSMutableArray arrayWithCapacity:0];
    AuthtionSeconController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionSeconController"];
    vc.IDCardmageArr = imageArr;
    //切换图片数据格式
    NSString *oneData = [forwardData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *twoData = [backData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    
    NSDictionary *oneDic = [[NSDictionary alloc] initWithObjectsAndKeys:oneImageName,@"fileName",imageType,@"fileType",oneData,@"imgData",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //第一张图片上传
    [WebAPI uploadIDCardImage:oneDic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSDictionary *dic = [response objectForKey:@"data"];
            [imageIDArr addObject:[dic objectForKey:@"affix_id"]];
            //第二张图片上传
            NSDictionary *oneDic = [[NSDictionary alloc] initWithObjectsAndKeys:twoImageName,@"fileName",imageType,@"fileType",twoData,@"imgData",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key", nil];
            [WebAPI uploadIDCardImage:oneDic callback:^(NSError *err, id response) {
                if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                    
                    
                    
                    NSDictionary *dic = [response objectForKey:@"data"];
                    [imageIDArr addObject:[dic objectForKey:@"affix_id"]];
                    vc.imageIDNumArr = imageIDArr;
                    vc.renterType = self.renterType;
                    vc.personName = idName;
                    vc.personIDNum = idNumber;
                    vc.mutDictionary = self.mutDictionary;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //如果是从签约或者签约详情进入的，返回身份证照
                    if ([self.wayIn isEqualToString:@"SignRoom"]) {
                        
                        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.forwardIDImg.image,@"front",self.backIDImg.image,@"back",imageArr[0],@"frontID",imageArr[1],@"backID", nil];
                        [self.delegate passValueForSignRoom:dic];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                         [self.navigationController pushViewController:vc animated:YES];
                    }
                }else{
                    RequestBadByNoNav
                }
            }];
        }else{
            RequestBad
        }
    }];
}
/**
 根据身份证正面照，获取信息
 */
-(void)authtionIDCardImage{
//    NSString *apiKey = @"73c9a29e-0168-4081-b4e2-6f008bd98f63";
    NSString *apiKey = @"fb674efc-8882-4d53-92d1-2d1e729303a7";
    NSData *data =UIImageJPEGRepresentation(self.forwardIDImg.image, 0.2);
    UIImage *img = [UIImage imageWithData:data];
    
    //先认证身份证正面
    [sdk idCardImage:img apiKey:apiKey successBlock:^(id responseObject) {
        NSLog(@"正面---%@",responseObject );
        NSData *jsonData = [(NSString*)responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSString *code = [dic objectForKey:@"code"];
        if (code.integerValue == 0) {
            NSArray *stringArr = [[NSString stringWithFormat:@"%@",responseObject] componentsSeparatedByString:@","];
            
            NSArray *nameArr = [stringArr[2] componentsSeparatedByString:@":"];
            NSString *name = nameArr[1];
            idName = [[nameArr[1] substringFromIndex:1] substringToIndex:name.length-2];
            NSArray *idnumArr = [stringArr[9] componentsSeparatedByString:@":"];
            NSString *idnum = idnumArr[1];
            idNumber = [[idnum substringFromIndex:1] substringToIndex:idnum.length - 2];
            idName = [dic stringForKey:@"name"];
            idNumber = [dic stringForKey:@"idnumber"];
            if (idName.length>0 && idNumber.length >0) {
                isRightIDCard = YES;
            }else{
                isRightIDCard = NO;
            }
            
        }
        else{
            if (code.integerValue == 3320) {
                errCode = @"3320";
                errMsg = @"身份证识别失败,请重新提交有效的身份证照片";
            }else{
                errCode = code;
                errMsg = [NSString stringWithFormat:@"身份证识别失败(%@)",errCode];
            }
            isRightIDCard = NO;
        }
        
        
    } failureBlock:^(NSError *error) {
        [Alert showFail:@"身份证正面照识别失败！" View:self.view andTime:1.5 complete:nil];
        isRightIDCard = NO;
    }];
}
///3320--身份证识别失败,请重新提交有效的身份证照片
///其他--身份证识别失败(错误码)
/**
 实名认证背面照
 */
-(void)authtionIDCardBackImage{
//    NSString *apiKey = @"4d79c1f0-3059-4769-8079-72a71fb1d514";4d79c1f0-3059-4769-8079-72a71fb1d514
    NSString *apiKey = @"01170ffa-f0e4-4ac8-936c-b3e3de68f090";
    NSData *data =UIImageJPEGRepresentation(self.backIDImg.image, 0.2);
    UIImage *img = [UIImage imageWithData:data];
    
    //先认证身份证正面
    [sdk idCardImage:img apiKey:apiKey successBlock:^(id responseObject) {
        
        NSArray *stringArr = [[NSString stringWithFormat:@"%@",responseObject] componentsSeparatedByString:@","];
        
        NSArray *nameArr = [stringArr[10] componentsSeparatedByString:@":"];
        NSString *name = nameArr[1];
        backMsg = [[nameArr[1] substringFromIndex:1] substringToIndex:name.length-2];
        
        
    } failureBlock:^(NSError *error) {
       [Alert showFail:@"身份证背面照识别失败！" View:self.view andTime:1.5 complete:nil];

    }];
}

@end
