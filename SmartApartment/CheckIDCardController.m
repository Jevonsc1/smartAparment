//
//  CheckIDCardController.m
//  SmartApartment
//
//  Created by Trudian on 17/3/9.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "CheckIDCardController.h"

@interface CheckIDCardController ()<UIScrollViewDelegate>

@end

@implementation CheckIDCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    scrollview.delegate = self;
    
    
    UIImageView *frontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT/2)];
    [frontImageView setImage:self.frontImage];
    frontImageView.contentMode =UIViewContentModeScaleAspectFit;
    frontImageView.centerY = SCREEN_HEIGHT/2-50;
    NSLog(@"front---%f",frontImageView.centerY);
    [frontImageView setContentScaleFactor:[[UIScreen mainScreen] scale]/2];
    frontImageView.contentMode =  UIViewContentModeScaleAspectFill;
    frontImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    frontImageView.clipsToBounds  = YES;
    
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH,SCREEN_HEIGHT/2)];
    [backImageView setImage:self.backImage];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollview setContentSize:CGSizeMake(2*self.view.width, 0)];
    backImageView.centerY = SCREEN_HEIGHT/2-50;
    NSLog(@"back-%f",backImageView.centerY);
    [backImageView setContentScaleFactor:[[UIScreen mainScreen] scale]/2];
    backImageView.contentMode =  UIViewContentModeScaleAspectFill;
    backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    backImageView.clipsToBounds  = YES;
    
    
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    [scrollview addSubview:frontImageView];
    [scrollview addSubview:backImageView];
    self.title = @"1/2";
    [self.view addSubview:scrollview];
    
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.title = [NSString stringWithFormat:@"%ld/2",[NSString stringWithFormat:@"%f",scrollView.contentOffset.x/self.view.width].integerValue+1];
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
