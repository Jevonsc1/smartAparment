//
//  communityDetailController.m
//  SmartApartment
//
//  Created by Trudian on 17/1/20.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "communityDetailController.h"
//#import "YKLoopView.h"
#import "UIImageView+WebCache.h"
#import "GBTagListView2.h"
#import "CheckImageController.h"
@interface communityDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *emptyRoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *allRoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *comMaster;
@property (weak, nonatomic) IBOutlet UILabel *comPhone;

@property (weak, nonatomic) IBOutlet UILabel *rentMoney;
@property (weak, nonatomic) IBOutlet UIView *tagView;

@end

@implementation communityDetailController
{
    NSMutableArray *images;
    UIScrollView *scrollview;
    GBTagListView2 *tagList;
    
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    images = [NSMutableArray arrayWithCapacity:0];
    //图片滚动
    for (int i = 0; i <self.model.communityPicAffixs.count; i++) {
        NSString *urlString = self.model.communityPicAffixs[i];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(i *self.view.width, 0, self.view.width, 281*ratio)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bannerView.width, self.bannerView.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
        scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.bannerView.height)];
        scrollview.contentSize = CGSizeMake(self.model.communityPicAffixs.count * self.bannerView.width, 0);
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [contentView addSubview:imageView];
        imageView.centerX = contentView.centerX;
        [scrollview addSubview:contentView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkImage:)];
        [imageView addGestureRecognizer:tap];
        [contentView addSubview:imageView];
    
    }
    
    if (self.model.communityPicAffixs.count == 1) {
        scrollview.scrollEnabled = NO;
        
    }
    [self.bannerView addSubview:scrollview];
    self.title = self.model.communityName;
    self.addressLabel.text = self.model.communityAddress;
    self.emptyRoomLabel.text = [NSString stringWithFormat:@"%@间",self.model.communityEmptyHouseAmount];
    self.allRoomLabel.text = [NSString stringWithFormat:@"%@间",self.model.communityHouseAmount];
    self.comMaster.text = self.model.communityBOName;
    self.comPhone.text = self.model.communityBOPhone;
    if ([self.model.communityHouseRentMax isEqualToString:self.model.communityHouseRentMin]) {
        self.rentMoney.text =[NSString stringWithFormat:@"%ld", (long)self.model.communityHouseRentMax.integerValue];
    }else{
        self.rentMoney.text = [NSString stringWithFormat:@"%@~%@",[NSString stringWithFormat:@"%ld",(long)self.model.communityHouseRentMin.integerValue],[NSString stringWithFormat:@"%ld",(long)self.model.communityHouseRentMax.integerValue]];
    }
    
    
    tagList = [[GBTagListView2 alloc] initWithFrame:CGRectMake(0, 0, self.tagView.width- 50, 0)];
    tagList.canTouch = NO;
    [tagList setTagWithTagArrayByDictionary:self.model.tagInfoList andType:@"detail"];
   
    [self.tagView addSubview:tagList];
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView setContentSize:CGSizeMake(0, 26*ratio*4+281*ratio+5*cellHeight + 47 + tagList.height -24 )];
     NSLog(@"标签高度--%f---滚动范围--%f",tagList.height,self.tableView.contentSize.height-(26*ratio*4+281*ratio+5*cellHeight + 47 ));

}
-(void)checkImage:(UIGestureRecognizer *)tap{
    UIImageView *imgV = (UIImageView *)tap.view;
    CheckImageController *vc = [[UIStoryboard storyboardWithName:@"SearchRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckImage"];
    vc.image = imgV.image;
    vc.index = (imgV.x + imgV.width) / self.view.width;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 281*ratio;
    }else if (indexPath.section == 1){
        return cellHeight;
    }else if(indexPath.section == 2){
        
            return cellHeight;
        
    }else if (indexPath.section == 3){
        
        return tagList.height+24;
    }
    else{
        return 47;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else
    {
    return 26*ratio;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 26*ratio)];
    view.backgroundColor = TDRGB(245.0,245.0, 245.0);
    //长条
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(17, 0, 7 *ratio, 17*ratio)];
    if (section == 1) {
        smallView.backgroundColor = MainBlue;
    }else if (section == 2){
        smallView.backgroundColor = MainRed;
    }else if(section == 3){
        smallView.backgroundColor = MainGreen;
    }
 
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width/2, 32*ratio)];
    
    label.font = [UIFont systemFontOfSize:14 *ratio];
    label.textColor = TDRGB(136.0, 136.0, 136.0);
    if (section == 1){
        label.text = @"房屋信息";
    }else if(section == 2){
        label.text = @"联系方式";
    }else if (section == 3){
        label.text = @"房间特色";
    }
    //边线
    UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    oneline.backgroundColor = TDRGB(223, 223, 223);
    UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
    twoline.backgroundColor = TDRGB(223, 223, 223);
    
    
    
    //添加控件
    [view addSubview:oneline];
    [view addSubview:twoline];
    [view addSubview:smallView];
    [view addSubview:label];
    smallView.centerY = view.centerY;
    label.centerY = view.centerY;
    label.x = smallView.x+smallView.width+8;
    
    if (section == 0) {
        return nil;
    }else{
     return view;
    }
}

- (IBAction)clickToCallPhone:(id)sender {
    NSString *phone = self.model.communityBOPhone;
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

@end
