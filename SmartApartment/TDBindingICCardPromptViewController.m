//
//  TDBindingICCardPromptViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/7.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDBindingICCardPromptViewController.h"

@interface TDBindingICCardPromptViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *button;
@end

@implementation TDBindingICCardPromptViewController

- (void)touchUpInside:(UIButton *)button {
    if ([[button currentTitle] isEqualToString:@"返回"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([[button currentTitle] isEqualToString:@"重新绑定"]) {
        for (UIViewController *controller in [self.navigationController viewControllers]) {
            if ([controller isKindOfClass:NSClassFromString(@"TDBindingICCardStartViewController")]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.view.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-107)/2, 64+50, 107, 107)];
    [self.view addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 247, SCREEN_WIDTH-40, 66)];
    [_label setFont:[UIFont systemFontOfSize:16]];
    [_label setNumberOfLines:0];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_label];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, 465, 160, 44)];
    [_button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setBackgroundColor:RGB(46, 126, 224)];
    [_button cornerRadius:3 color:RGB(46, 126, 224)];
    [self.view addSubview:_button];
    
    if (_status == BindingICCardStatusSuccess) {
        [self setTitle:@"发卡成功"];
        [_imageView setImage:[UIImage imageNamed:@"IDSureOk"]];
        [_label setText:@"恭喜您，您的 IC卡已经可以\n开门了，快来试试吧！"];
        [_label setTextColor:RGB(102, 177, 79)];
        
        [_button setTitle:@"返回" forState:UIControlStateNormal];
    }else if (_status == BindingICCardStatusFailure) {
        [self setTitle:@"发卡失败"];
        [_imageView setImage:[UIImage imageNamed:@"IDSureBad"]];
        if (_statusDesc) {
            [_label setText:_statusDesc];
        }else {
            [_label setText:@"IC卡绑定失败了……\n在指定的时间内没有读取到任何信息"];
        }
        [_label setTextColor:RGB(229, 89, 89)];
        
        [_button setTitle:@"重新绑定" forState:UIControlStateNormal];
    }
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
