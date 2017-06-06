//
//  AuthtionSeconController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/24.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AuthtionSeconController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ForNavigationController.h"
#import "AuthtionSureController.h"
#import "UIImage+fixOrientation.h"
@interface AuthtionSeconController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *handClickView;

@property (weak, nonatomic) IBOutlet UIImageView *handIDImg;

@end

@implementation AuthtionSeconController
{
     UIImagePickerController *_imagePickerController;
    
    NSString *imageType;
    NSString *imageName;
    NSData *imgData;
    
    BOOL hadHandImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"实名认证"];
    [self initImagePicker];
    [self initClickView];
    hadHandImage = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 点击按钮上传身份证照片

 */
- (IBAction)clickToSureUpLoad:(id)sender {
    if (!hadHandImage) {
        [Alert showFail:@"请拍摄手持身份证照片" View:self.view andTime:1.5 complete:nil];
        return;
    }
    NSMutableArray *imageArr =[NSMutableArray arrayWithCapacity:0];
    [imageArr addObjectsFromArray:self.IDCardmageArr];
    NSMutableArray *imageIDArr = [NSMutableArray arrayWithCapacity:0];
    [imageIDArr addObjectsFromArray:self.imageIDNumArr];
    
    //将图片数据base64编码
    NSString *oneData = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSDictionary *oneDic = [[NSDictionary alloc] initWithObjectsAndKeys:imageName,@"fileName",imageType,@"fileType",oneData,@"imgData",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI uploadIDCardImage:oneDic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSDictionary *dic = [response objectForKey:@"data"];
            [imageArr addObject:self.handIDImg.image];
            [imageIDArr addObject:[dic objectForKey:@"affix_id"]];
            NSDictionary *imageDic = [[NSDictionary alloc] initWithObjectsAndKeys:imageArr,@"images",imageIDArr,@"imageIDs", nil];
            ForNavigationController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"ForNavigationController"];
            vc.imageDic = imageDic;
            vc.renterType = self.renterType;
            vc.idNumber = self.personIDNum;
            vc.idName = self.personName;
            vc.mutDictionary = self.mutDictionary;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            RequestBadByNoNav
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

-(void)initClickView{
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePictureHandImage)];
    [self.handClickView addGestureRecognizer:backTap];
}

/**
 拍摄手持身份证照片
 */
-(void)takePictureHandImage{
    [self selectImageFromCamera];
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
    
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
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
        imageName = @"hand.jpg";
        
    }else{
        imageType = @"png";
        imageName = @"hand.png";
        
    }
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //判断是正面还是反面照
       
            self.handIDImg.image =[info[UIImagePickerControllerOriginalImage] fixOrientation];
            //压缩图片---用于上传到服务器的图片数据
            imgData = UIImageJPEGRepresentation(self.handIDImg.image, 0.5);
        hadHandImage = YES;
     
        
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
