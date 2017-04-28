//
//  WebBookController.m
//  SmartApartment
//
//  Created by Trudian on 16/11/23.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "WebBookController.h"

@interface WebBookController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebBookController
{
    UserData *user;
    NSString *url;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    user = [ModelTool find_UserData];
    //安全承诺shu
 
}
-(void)viewWillAppear:(BOOL)animated{


    if ([self.bookType isEqualToString:@"safe"]) {
        self.title = @"安全承诺书";
        if ([user.memberType isEqualToString:@"master"]) {
            url = [NSString stringWithFormat:@"http://wisdomhouse.trudian.com/service/misc/userAgreement?key=%@&houseID=%@",user.key,self.houseID];
        }else{
            url =  [NSString stringWithFormat:@"http://wisdomhouse.trudian.com/service/misc/userAgreement?key=%@&houseID=%@",user.key,self.houseID];
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
   
    }else{
        self.title = @"合约书";
        if ([user.memberType isEqualToString:@"master"]) {
            url = [NSString stringWithFormat:@"http://wisdomhouse.trudian.com/service/misc/myContract?key=%@&houseID=%@",user.key,self.houseID];
        }else{
            url =  [NSString stringWithFormat:@"http://wisdomhouse.trudian.com/service/misc/myContract?key=%@&houseID=%@",user.key,self.houseID];
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
    }
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
