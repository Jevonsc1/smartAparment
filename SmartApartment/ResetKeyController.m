//
//  ResetKeyController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/28.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "ResetKeyController.h"
#import<CommonCrypto/CommonDigest.h>
@interface ResetKeyController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *onePwd;
@property (weak, nonatomic) IBOutlet UITextField *twoPwd;

@end

@implementation ResetKeyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickToSure:(id)sender {
    if ( [self.username.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0) {
     
//        [XHToast showTopWithText:@"请输入姓名!"];
        
        return;
    }
    if (self.username.text.length >5) {
//        [XHToast showTopWithText:@"租客姓名最多5个汉子字"];
        return;
    }
    if ([self.onePwd.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<6 ) {
//        [XHToast showTopWithText:@"第一次输入的密码不正确!"];
       
        return;
    }
    if ([self.twoPwd.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<6 ) {
//        [XHToast showTopWithText:@"第二次输入的密码不正确!"];
       
        return;
    }
    if (![self.onePwd.text isEqualToString:self.twoPwd.text]) {
//        [XHToast showTopWithText:@"两次输入的密码不一致!"];
        return;
    }
    NSString *pwd = [self md5:self.twoPwd.text];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",pwd,@"memberPassword",self.username.text,@"memberName", nil];
    [WebAPI editVirtualMemberInfo:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            [Alert showFail:@"修改密码成功！" View:self.navigationController.navigationBar andTime:1 complete:^(BOOL isComplete) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            RequestBad
        }
        
    }];
    
}
- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
