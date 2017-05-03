//
//  BBImagebaseVC.m
//  imgeChoose
//
//  Created by williamliuwen on 16/11/19.
//  Copyright © 2016年 williamliuwen. All rights reserved.
//

#import "BBImagebaseVC.h"
#import <AVFoundation/AVFoundation.h>

@interface BBImagebaseVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIAlertController *alertController;
@end

@implementation BBImagebaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)takeBBImage{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        [self showAlertController];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"無法存取相機" message:@"請至 設定>隱私權 中開啟權限" preferredStyle:UIAlertControllerStyleAlert];
        
        // 確定按鈕
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 取得編輯後的圖片 UIImage
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if (img == nil) {
        // 如果沒有編輯 則是取得原始拍照的照片 UIImage
        img = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    // 再來就是對圖片的處理 img 是一個 UIImage
    if (self.returnBBImageBlock != nil) {
        self.returnBBImageBlock(img);
    }
    
    //移除Picker
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertController{
    _alertController = [[UIAlertController alloc]init];
    
    UIAlertAction *bbCarmra = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //建立一個ImagePickerController
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // 設定影像來源 這裡設定為相機
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // 設置 delegate
        imagePicker.delegate = self;
        
        // 設置拍照完後 可以編輯 會多一個編輯照片的步驟
        imagePicker.allowsEditing = YES;
        
        // 顯示相機功能
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *bbPhoto = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //建立一個ImagePickerController
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // 設定影像來源 這裡設定為相機
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        
        // 設置 delegate
        imagePicker.delegate = self;
        
        // 設置拍照完後 可以編輯 會多一個編輯照片的步驟
        imagePicker.allowsEditing = YES;
        
        // 顯示相機功能
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *bbCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [_alertController addAction:bbCarmra];
    [_alertController addAction:bbPhoto];
    [_alertController addAction:bbCancle];
    
    [self presentViewController:_alertController animated:YES completion:^{
        
    }];
}

//****************************************
//****************************************
//****************************************
//****************************************
//****************************************
//****************************************
//****************************************



@end
