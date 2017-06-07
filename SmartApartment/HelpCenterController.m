//
//  HelpCenterController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "HelpCenterController.h"

@interface HelpCenterController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HelpCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wisdomhouse.trudian.com/service/misc/helper"]]];
    //http://wisdomhouse.trudian.com/service/misc/helper
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}



@end
