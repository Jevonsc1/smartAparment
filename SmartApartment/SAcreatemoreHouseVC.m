//
//  SAcreatemoreHouseVC.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//  批量创建房屋界面

#import "SAcreatemoreHouseVC.h"

#import "SAhouseCell.h"
//#import "SAhouseModel.h"

#import "SAcreathouseFinishVC.h"

//#import "SAHitView.h"

#import "SAhouseView.h"

@interface SAcreatemoreHouseVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *fistView;

@property (weak, nonatomic) IBOutlet UITextField *rentMoneyString;//月租
//押金的两个按键
@property (weak, nonatomic) IBOutlet UIButton *depositBtnOne;
@property (weak, nonatomic) IBOutlet UIButton *depositBtnTwo;

@property (weak, nonatomic) IBOutlet UITextField *depositMoneyString;//押金或押金比例
@property (weak, nonatomic) IBOutlet UILabel *depositPersentLabel;
@property (weak, nonatomic) IBOutlet UITextField *roomCount;//楼层数

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeightView;

@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
//传的值

//@property(nonatomic,strong)NSMutableArray *houseLayerCountArray;
@property(nonatomic,strong)NSMutableDictionary *houseLayerCountDict;
@property(nonatomic,strong)UIScrollView *scrollViewIn;
//@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,assign)int roomArray;
@property(nonatomic,strong)NSMutableArray *houseLayerArray;
@end

@implementation SAcreatemoreHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self defaultSet];
    self.roomCount.delegate=self;
    self.roomCount.tag=10000;
    self.rentMoneyString.tag=10001;
    self.depositMoneyString.tag=10002;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLayer:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)defaultSet{
    self.depositBtnTwo.selected=NO;
    self.depositBtnOne.selected=YES;
    [self.depositPersentLabel setText:@"元"];
    self.depositMoneyString.text =@"";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.scrollViewIn==nil) {
        self.scrollViewIn =[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.fistView.height+self.fistView.y, self.view.frame.size.width, self.view.height-self.fistView.height-100)];
        [self.scrollView addSubview:self.scrollViewIn];
    }
}


//创建房间列表
- (void)showLayer:(NSNotification*)info{
    
    UITextField *textField =info.object;
    if (textField.tag==10000) {
        [self.houseLayerCountDict removeAllObjects];
        for(UIView *view in [self.scrollViewIn subviews]){
            [view removeFromSuperview];
        }
        [self.houseLayerArray removeAllObjects];
        int num =[textField.text intValue];
        for (int i=0; i<num; i++) {
            [self.houseLayerArray addObject:[NSString stringWithFormat:@"%d",i+1]];
        }

        [self addView:num];
    }else if (textField.tag==10001){
        return;
    }else if (textField.tag==10002){
        return;
    }else {
        //房间数量
        if (textField.text.length==0) {
            [self.houseLayerCountDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
            
            return;
        }
        [self.houseLayerCountDict setValue:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
    
    }
}

- (void)addView:(int)count{

    CGFloat scrollerHeight =0;
    for (int i =0;i<count; i++) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SAhouseView" owner:self options:nil];
        SAhouseView *houseView = [nib objectAtIndex:0];
        houseView.houseLayer.text=[NSString stringWithFormat:@"%d",i+1];
        houseView.houseCount.delegate=self;
        houseView.houseCount.keyboardType=UIKeyboardTypeNumberPad;
        houseView.houseCount.tag=i+1;
        
        CGFloat viewX=0;
        CGFloat viewW=self.scrollViewIn.frame.size.width;
        CGFloat viewH=50 *ratio;
        CGFloat viewY=i*viewH;
        scrollerHeight +=viewH;
        
        [houseView setFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        [self.scrollViewIn addSubview:houseView];
    }
    
    [self.scrollViewIn setContentSize:CGSizeMake(self.scrollViewIn.frame.size.width, scrollerHeight)];
    
    [self initBtn];
}


- (IBAction)popVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBtn{
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:TDGROBAL_COLOR];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchDown];
    [btn setFrame:CGRectMake(0, self.scrollViewIn.y+self.scrollViewIn.height+20, 205, 38)];
    [btn setCenterX:self.view.centerX];
    btn.layer.cornerRadius=8;
    [self.view addSubview:btn];
}

#pragma mark - 跳转

- (void)clickBtn{
    [self.view endEditing:YES];
    
    if (self.rentMoneyString.text.length==0) {
        [Alert showFail:@"请填写租金" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.depositMoneyString.text.length==0) {
        [Alert showFail:@"请填写押金比例" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.roomCount.text.length==0) {
        [Alert showFail:@"请填写层数" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    SAcreathouseFinishVC *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"SAcreathouseFinishVC"];
    vc.rentMoneyString = self.rentMoneyString.text;
    if (self.depositBtnOne.selected) {
        vc.depostiMoneyString=self.depositMoneyString.text;
    }else{
        float deposi =self.depositMoneyString.text.floatValue * self.rentMoneyString.text.floatValue;
        vc.depostiMoneyString=[NSString stringWithFormat:@"%0.f",deposi];
    }

    vc.houseDict=self.houseLayerCountDict;
    vc.community = self.community;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseLayerArray.count;
}

//- (void)addTableView{
////todo
////原来是TDTableView 我换了为UITableView
//    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.fistView.height+self.fistView.y, self.view.frame.size.width, self.view.height-self.fistView.height-100)];
//    tableView.delegate   = self;
//    tableView.dataSource = self;
//    [tableView registerNib:[UINib nibWithNibName:@"SAhouseCell" bundle:nil]  forCellReuseIdentifier:@"SAhouseCell"];
//    self.tableView = tableView;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.scrollView addSubview:tableView];
//    
//    [self initBtn];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString *cellIdentifier = @"SAhouseCell";
//    SAhouseCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
//    cell.houseLayerCount.delegate=self;
//    cell.houseLayerCount.tag=indexPath.row+1;
//    if (cell == nil) {
//        cell = [[SAhouseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
//    }
//    
//    cell.layerString = self.houseLayerArray[indexPath.row];
//    return cell;
//}

- (NSMutableArray *)houseLayerArray{
    if (_houseLayerArray == nil) {
        _houseLayerArray = [NSMutableArray array];
    }
    return _houseLayerArray;
}

//- (NSMutableArray *)houseLayerCountArray{
//    if (_houseLayerCountArray == nil) {
//        _houseLayerCountArray = [NSMutableArray array];
//    }
//    return _houseLayerCountArray;
//}
- (IBAction)clickDepostiBtnOne:(id)sender {
    //固定押金
    self.depositBtnTwo.selected=NO;
    self.depositBtnOne.selected=YES;
    [self.depositBtnOne setImage:[UIImage imageNamed:@"isRight_icon"] forState:UIControlStateNormal];
    [self.depositBtnTwo setImage:[UIImage imageNamed:@"isNotRight_icon"] forState:UIControlStateNormal];
    [self.depositPersentLabel setText:@"元"];
    self.depositMoneyString.text =@"";
    self.depositMoneyString.placeholder = @"请填写金额";
}



- (IBAction)clickDepositBtnTwo:(id)sender {
    //按月押金
    self.depositBtnTwo.selected=YES;
    self.depositBtnOne.selected=NO;
    [self.depositBtnTwo setImage:[UIImage imageNamed:@"isRight_icon"] forState:UIControlStateNormal];
    [self.depositBtnOne setImage:[UIImage imageNamed:@"isNotRight_icon"] forState:UIControlStateNormal];
    [self.depositPersentLabel setText:@"个月房租"];
    self.depositMoneyString.text =@"";
    self.depositMoneyString.placeholder = @"请填写押金比例";

}

- (NSMutableDictionary *)houseLayerCountDict{
    if (_houseLayerCountDict==nil) {
        _houseLayerCountDict=[NSMutableDictionary dictionary];
    }
    return _houseLayerCountDict;
}


@end
