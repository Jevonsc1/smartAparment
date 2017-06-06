//
//  TDBindingICCardBaseViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/7.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDBindingICCardBaseViewController.h"

@interface TDBindingICCardBaseViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation TDBindingICCardBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH*0.53)];
    [_imageView setImage:[UIImage imageNamed:@"IC卡发卡"]];
    [_imageView setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:_imageView];
    
    _operatingButton = [[UIButton alloc] init];
    [self.view addSubview:_operatingButton];
    [_operatingButton addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    _operatingPromptLabel = [[UILabel alloc] init];
    [_operatingPromptLabel setFont:[UIFont systemFontOfSize:14]];
    [_operatingPromptLabel setNumberOfLines:0];
    [_operatingPromptLabel setTextColor:RGB(153, 153, 153)];
    [_operatingPromptLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_operatingPromptLabel];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (_operatingButton) {
        if ([keyPath isEqualToString:@"frame"]) {
            CGRect frame = _operatingButton.frame;
            if (frame.size.width == frame.size.height) {
                [_operatingPromptLabel setFrame:CGRectMake(20, frame.origin.y+frame.size.height+22, SCREEN_WIDTH-40, 64)];
            }else {
                [_operatingPromptLabel setFrame:CGRectMake(20, frame.origin.y+frame.size.height+44, SCREEN_WIDTH-40, 64)];
            }
        }
    }
}

- (void)dealloc
{
    if (_operatingButton) {
        [_operatingButton removeObserver:self forKeyPath:@"frame"];
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
