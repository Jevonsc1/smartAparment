//
//  STPickerArea.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerArea.h"

#import "Geography.h"


@interface STPickerArea()<UIPickerViewDataSource, UIPickerViewDelegate>


/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;

@property(nonatomic,strong,nullable)NSMutableArray *areaIDArr;


/** 6.省份 */
@property (nonatomic, strong, nullable)NSString *province;
/** 7.城市 */
@property (nonatomic, strong, nullable)NSString *city;
/** 8.地区 */
@property (nonatomic, strong, nullable)NSString *area;

@property(nonatomic,strong)NSMutableArray *areaMutableArea;

@property(nonatomic,assign)NSInteger cityIndexth;

@end

@implementation STPickerArea
{
    NSString *nodeID;
}
#pragma mark - --- init 视图初始化 ---

- (void)setupUI:(NSArray*)array
{
    self.cityIndexth = 18;
    NSInteger cityRowNum=17;
    
    [self.areaMutableArea addObjectsFromArray:array];
    
    
    for (Geography* province in array) {
        [self.arrayProvince addObject:province.node_name];
    }
    
   Geography* province = array[self.cityIndexth];
    for (Geography* city in province.sub) {
        [self.arrayCity addObject:city.node_name];
    }
    
    Geography* city = province.sub[cityRowNum];
    for (Geography* area in city.sub) {
        [self.arrayArea addObject:area.node_name];
        [self.areaIDArr addObject:area.node_id];
    }
    
    
    
    self.province=@"广东";
    self.city=@"中山市";
    self.area=@"石岐区";
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.area];
    

    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    [self setTitle:text];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    //不能放在前面
    [self.pickerView selectRow:self.cityIndexth inComponent:0 animated:NO];
    [self.pickerView selectRow:cityRowNum inComponent:1 animated:NO];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];// 强制立即存入沙盒
    [defaults setObject:@"3145" forKey:@"nodeID"];
    
}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayProvince.count;
    }else if (component == 1) {
        return self.arrayCity.count;
    }else{
        return self.arrayArea.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        Geography* province = self.areaMutableArea[row];
        [self.arrayCity removeAllObjects];
        for (Geography* city in province.sub) {
            [self.arrayCity addObject:city.node_name];
        }
        
        Geography* city = province.sub[0];
        [self.arrayArea removeAllObjects];
        [self.areaIDArr removeAllObjects];
        for (Geography* area in city.sub) {
            [self.arrayArea addObject:area.node_name];
            [self.areaIDArr addObject:area.node_id];
            nodeID = area.node_id;
        }
//        nodeID = placeModel.node_id;
        
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else if (component == 1) {
 
        Geography* province = self.areaMutableArea[self.cityIndexth];
        Geography* city = province.sub[row];
        [self.arrayArea removeAllObjects];
        [self.areaIDArr removeAllObjects];
        for (Geography* area in city.sub) {
            [self.arrayArea addObject:area.node_name];
            [self.areaIDArr addObject:area.node_id];
            nodeID = area.node_id;
        }
 
   
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else{

        nodeID = self.areaIDArr[row];

    }
    
    
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    NSString *text;
    if (component == 0) {
        text =  self.arrayProvince[row];
    }else if (component == 1){
        text =  self.arrayCity[row];
    }else{
        if (self.arrayArea.count > 0) {
            text = self.arrayArea[row];
        }else{
            text =  @"";
        }
    }
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    [self.delegate pickerArea:self province:self.province city:self.city area:self.area nodeID:nodeID];
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.province = self.arrayProvince[index0];
    self.city = self.arrayCity[index1];
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[index2];
    }else{
        self.area = @"";
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.area];
    [self setTitle:title];

}

#pragma mark - --- setters 属性 ---

#pragma mark - --- getters 属性 ---


- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = [NSMutableArray array];
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = [NSMutableArray array];
    }
    return _arrayCity;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
        _arrayArea = [NSMutableArray array];
    }
    return _arrayArea;
}

- (NSMutableArray *)areaMutableArea{
    if (_areaMutableArea == nil) {
        _areaMutableArea = [NSMutableArray array];
    }
    return _areaMutableArea;
}
-(NSMutableArray *)areaIDArr{
    if (_areaIDArr == nil) {
        _areaIDArr = [NSMutableArray array];
    }
    return _areaIDArr;
}

@end


