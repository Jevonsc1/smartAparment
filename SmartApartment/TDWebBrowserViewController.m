//
//  TDWebBrowserViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/3/1.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDWebBrowserViewController.h"

@interface TDWebBrowserViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@end

@implementation TDWebBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [_webView setScalesPageToFit:YES];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_imageLink) {
        if (![_imageLink hasPrefix:@"http://"] && ![_imageLink hasPrefix:@"https://"]) {
            _imageLink = [NSString stringWithFormat:@"http://%@", _imageLink];
        }
        NSURL *url = [NSURL URLWithString:_imageLink];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (webTitle) {
        [self setTitle:webTitle];
    }
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
