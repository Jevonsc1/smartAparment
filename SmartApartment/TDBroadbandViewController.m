//
//  TDBroadbandViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/23.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDBroadbandViewController.h"
#import "TDPricingPackageListViewController.h"
#import "TDWebBrowserViewController.h"
#import "UIImageView+WebCache.h"

@interface TDBroadbandViewController ()

@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *immediatelyOpenedButton;

@property (strong, nonatomic) NSArray *imageUrls;
@end

@implementation TDBroadbandViewController

- (void)loadHostAdvInfoList {
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"version":@"2.0"};
    
    [WebAPIForBroadband loadHostAdvInfoList:dictionary callback:^(NSError *err, id response) {
        if (err) {
            NSLog(@"%@",err.domain);
            return;
        }
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSArray *result = [response arrayForKey:@"data"];
            NSLog(@"%@",result);
            //[result createPropertyCode];
            [self reloadData:result];
        }else {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
        }
    }];
}

- (void)reloadData:(NSArray *)array {
    if (array) {
        _imageUrls = array;
        if ([_imageUrls count] > 0) {
            NSDictionary *dictionary = [_imageUrls dictionaryAtIndex:0];
            //[_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[dictionary stringForKey:@"advImageURL"]] placeholderImage:[UIImage imageNamed:@"公寓宽带"]];
            [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[dictionary stringForKey:@"advImageURL"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (!image) {
                    [_backgroundImageView setImage:[UIImage imageNamed:@"公寓宽带"]];
                }
            }];
        }
    }
}

- (void)touchUpInsideForImageView:(UITapGestureRecognizer *)tap {
    
    if ([_imageUrls count] > 0) {
        NSDictionary *dictionary = [_imageUrls dictionaryAtIndex:0];
        NSString *imageLink = [dictionary stringForKey:@"advImageLink"];
        if (![imageLink isEqualToString:@""]) {
            TDWebBrowserViewController *controller = [[TDWebBrowserViewController alloc] init];
            controller.imageLink = imageLink;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (IBAction)touchUpInside:(UIButton *)button {
    
    if (button == _goBackButton) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (button == _immediatelyOpenedButton) {
        TDPricingPackageListViewController *controller = [[TDPricingPackageListViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_backgroundImageView];
        [self.view sendSubviewToBack:_backgroundImageView];
        
    }
    [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_backgroundImageView setClipsToBounds:YES];
//    [_backgroundImageView setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInsideForImageView:)];
//    [_backgroundImageView addGestureRecognizer:tap];
    
    [_immediatelyOpenedButton cornerRadius];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self loadHostAdvInfoList];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

@end
