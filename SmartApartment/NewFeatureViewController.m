//
//  NewFeatureViewController.m
//  HuiChengHang
//
//  Created by ZhengJevons on 15/12/18.
//  Copyright © 2015年 ZhengJevons. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "TDTabViewController.h"
#define PAGENUM 5
@interface NewFeatureViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIPageControl* page;

@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupScroll];
    [self setupPageControl];
    
}


-(void)setupPageControl{
    UIPageControl* page=[[UIPageControl alloc]init];
    page.numberOfPages=PAGENUM;
    CGFloat pageW=30;
    CGFloat pageH=5;
    page.bounds = CGRectMake(0, 0, pageW, pageH);
    page.center = CGPointMake(self.view.frame.size.width*0.5,self.view.frame.size.height*0.95);
    
    page.currentPageIndicatorTintColor = TDRGB(46, 126, 224);;
    page.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:page];
    self.page=page;
}

-(void)setupScroll{
    UIScrollView* scroll=[[UIScrollView alloc]init];
    CGFloat imgheight=self.view.frame.size.height;
    CGFloat imgwidth=self.view.frame.size.width;
    scroll.frame=self.view.bounds;
    for (int index=0; index<PAGENUM; index++) {
        NSString* img=[NSString stringWithFormat:@"new_feature%d",index+1];
        UIImageView* imageview=[[UIImageView alloc]init];
        imageview.image=[UIImage imageNamed:img];
        CGFloat imgX=index*imgwidth;
        imageview.frame=CGRectMake(imgX, 0, imgwidth, imgheight);
        if (index==PAGENUM-1) {
            imageview.userInteractionEnabled = YES;
            [self startLastImageView:imageview];
        }
        [scroll addSubview:imageview];
    }
    scroll.contentSize=CGSizeMake(PAGENUM*imgwidth, imgheight);
    scroll.pagingEnabled=YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.delegate=self;
    scroll.bounces=NO;
    [self.view addSubview:scroll];

    
}

-(void)startLastImageView:(UIImageView*)imageview
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(start)];
    [imageview addGestureRecognizer:tap];
    
}

-(void)start
{
    //    self.view.window.rootViewController=[[JWTabBarController alloc]init];
    TDTabViewController* tabVC = [[TDTabViewController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;


}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX=scrollView.contentOffset.x/self.view.bounds.size.width;
    int index=(int)(offsetX+0.5);
    self.page.currentPage=index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
