//
//  HouseHistoryController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "HouseHistoryController.h"
#import "HouseHistoryCell.h"
@interface HouseHistoryController ()

@end

@implementation HouseHistoryController
{
    //section展开闭合
    NSMutableArray *sectionArr;
    //section箭头
    NSMutableArray *sectionAnchorArr;
    //section点击收起
    NSMutableArray *sectionLabelArr;
    //水费
    NSArray *waterInfoArr;
    //电费
    NSArray *electricInfoArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1-代表展开section,0代表收起section
    sectionArr = [NSMutableArray arrayWithObjects:@"1",@"1",@"1", nil];
    sectionAnchorArr = [NSMutableArray arrayWithCapacity:0];
    sectionLabelArr = [NSMutableArray arrayWithCapacity:0];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.title = self.house.houseNum.stringValue;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.house.houseID,@"houseID", nil];
    [WebAPI getHouseRecordLog:dic callback:^(NSError *err, id response) {
        if ([NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000 && !err) {
            NSDictionary *dic = [response objectForKey:@"data"];
            waterInfoArr = [dic objectForKey:@"waterInfo"];
            electricInfoArr = [dic objectForKey:@"electricInfo"];
            
            [self.tableView reloadData];
        }else{
            RequestBad
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickToPop:(id)sender {
    [PopHome popToController:@"ShowCheckHouseController" andVC:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionNum = sectionArr[section];
    if ([sectionNum isEqualToString:@"1"]) {
        if (section == 0) {
              return electricInfoArr.count;
        }else if (section == 1){
            return waterInfoArr.count;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HouseHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseHistoryCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        NSDictionary *electricDic = electricInfoArr[indexPath.row];
        cell.readNum.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[electricDic objectForKey:@"recordValue"]].floatValue];
        cell.inputTime.text = [NSString stringWithFormat:@"%@",[TimeDate timeDetailWithTimeIntervalString:[electricDic objectForKey:@"createTime"]]];
        [cell.cellIcon setImage:[UIImage imageNamed:@"check_dian_icon"]];
    }else if (indexPath.section == 1){
        NSDictionary *waterDic = waterInfoArr[indexPath.row];
        cell.readNum.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[waterDic objectForKey:@"recordValue"]].floatValue];
        cell.inputTime.text = [NSString stringWithFormat:@"%@",[TimeDate timeDetailWithTimeIntervalString:[waterDic objectForKey:@"createTime"]]];
        [cell.cellIcon setImage:[UIImage imageNamed:@"check_water_icon"]];
    }else{
        [cell.cellIcon setImage:[UIImage imageNamed:@"check_ranqi_icon"]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*ratio;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    view.backgroundColor = TDRGB(245.0,245.0, 245.0);
    //长条
   
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(18 *ratio, 0, 7 *ratio, 17*ratio)];
    
 
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width/2, 32*ratio)];
    label.text = @"电表";
    label.font = [UIFont systemFontOfSize:14*ratio];
    label.textColor = TDRGB(136.0, 136.0, 136.0);
    //边线
    UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    oneline.backgroundColor = TDRGB(223, 223, 223);
    UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
    twoline.backgroundColor = TDRGB(223, 223, 223);
    //点击收起
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width-26, view.centerY-5.5, 17.5, 11)];
    [imgV setImage:[UIImage imageNamed:@"check_up_anchor"]];
    [sectionAnchorArr addObject:imgV];
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width/2-imgV.width-26, 0, self.view.width/2, 32*ratio)];
    rightLabel.textAlignment = NSTextAlignmentRight;
    NSString *sectionType = sectionArr[section];
    if ([sectionType isEqualToString:@"1"]) {
         rightLabel.text = @"点击收起";
    }else{
         rightLabel.text = @"点击展开";
    
            [imgV setTransform:CGAffineTransformMakeRotation(M_PI)];
       
    }
    if (section%3 == 0) {
        label.text = @"电表";
        smallView.backgroundColor = MainBlue;
    }else if(section%3 == 1){
        label.text = @"水表";
        smallView.backgroundColor = MainRed;
    }else{
        label.text = @"燃气";
        smallView.backgroundColor = MainGreen;
    }
    [sectionLabelArr addObject:rightLabel];
    rightLabel.font = [UIFont systemFontOfSize:14*ratio];
    rightLabel.textColor =  TDRGB(136.0, 136.0, 136.0);
    
    //添加控件
    [view addSubview:imgV];
    [view addSubview:rightLabel];
    [view addSubview:oneline];
    [view addSubview:twoline];
    [view addSubview:smallView];
    [view addSubview:label];
    smallView.centerY = view.centerY;
    label.centerY = view.centerY;
    label.x = smallView.x+smallView.width+8;
    
    //每个section的view添加点击收起的手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animationForSection:)];
    [view addGestureRecognizer:tap];
    //每个view的tag
    view.tag = section;
    return view;
}
//收起section下的cell
-(void)animationForSection:(UITapGestureRecognizer *)tap{
    NSString *sectionType = sectionArr[tap.view.tag];
 
    if ([sectionType isEqualToString:@"1"]) {
        [sectionArr replaceObjectAtIndex:tap.view.tag withObject:@"0"];
      
        
    }else{
         [sectionArr replaceObjectAtIndex:tap.view.tag withObject:@"1"];
         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tap.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
     
    }
      [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tap.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

@end
