//
//  UserContentController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "UserContentController.h"

@interface UserContentController ()
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation UserContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wisdomhouse.trudian.com/service/misc/protocol"]];
    
    [self.webView loadRequest:request];
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
