//
//  SearchBillController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SearchBillController.h"
#import "GBTagListView.h"


@interface SearchBillController ()
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIView *searchHistory;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@end

@implementation SearchBillController
{
    //标签view
    GBTagListView*_tempTag;
    //保存标签数据的数组
    NSMutableArray *strArray;
    GBTagListView *tagList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchView.layer.cornerRadius = 5;
  
    self.searchText.font = [UIFont systemFontOfSize:14*ratio];
    NSString *str = @"房间名/租客名/手机号";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:str];
    [placeholder addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:14*ratio]
                       range:NSMakeRange(0, str.length)];
    self.searchText.attributedPlaceholder = placeholder;

}
-(void)viewWillAppear:(BOOL)animated{
    NSString *searchStr = [ModelTool find_UserData].searchList;
    NSArray *searchArr = [searchStr componentsSeparatedByString:@","];
    strArray = [NSMutableArray arrayWithArray:searchArr];
    [self addTagView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchBill:(id)sender {
 
    if (self.searchText.text.length >0) {
        NSString *newSearch;
        if (strArray.count == 0) {
            [strArray addObject:self.searchText.text];
        }
        if ( ! [strArray containsObject:self.searchText.text]) {
            [strArray addObject:self.searchText.text];
        }
        
        for (int i = 0 ; i<strArray.count; i++) {
            NSString *appendStr = strArray[i];
            
            if (i == 0 ) {
                newSearch = appendStr;
            }else{
                newSearch = [newSearch stringByAppendingString:[NSString stringWithFormat:@",%@",appendStr]];
            }
            
        }
        
        [ModelTool find_UserData].searchList = newSearch;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSManagedObjectContext *privateContext= [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
            [privateContext MR_saveToPersistentStoreAndWait];
        });

 
        if (self.wayIn== 1) {
            dispatch_after(1.0, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchBill" object:self.searchText.text ];
            });
        }else{
            dispatch_after(1.0, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchRoom" object:self.searchText.text ];
            });
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 
 搜索添加历史数据

 */

- (IBAction)clickToPop:(id)sender {
    if (self.wayIn == 1) {
         [PopHome popToController:@"ApartmentBillController" andVC:self];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
 清空搜索历史
 */
- (IBAction)clickToClearHistory:(id)sender {
    [ModelTool find_UserData].searchList = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSManagedObjectContext *privateContext= [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
        [privateContext MR_saveToPersistentStoreAndWait];
    });
    [tagList setTagWithTagArray:nil];
    [Alert showFail:@"清空搜索历史成功！" View:self.navigationController.navigationBar andTime:1 complete:nil];
}
//添加标签的view
-(void)addTagView{
    
    tagList=[[GBTagListView alloc]initWithFrame:CGRectMake(0, 20,self.searchHistory.width-60, self.searchHistory.height)];
    /**允许点击 */
    tagList.canTouch=YES;
    /**可以控制允许点击的标签数 */
    tagList.canTouchNum=1;
    /**控制是否是单选模式 */
    tagList.isSingleSelect=NO;
    tagList.signalTagColor=[UIColor whiteColor];
    [tagList setTagWithTagArray:strArray];
    __block SearchBillController *blockSelf = self;
    [tagList setDidselectItemBlock:^(NSArray *arr) {
        blockSelf->_searchText.text = arr[0];
        
        if (blockSelf->_wayIn== 1) {
            dispatch_after(1.0, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchBill" object:blockSelf->_searchText.text ];
            });
        }else{
            dispatch_after(1.0, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchRoom" object:blockSelf->_searchText.text ];
            });
        }
        
        [blockSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.searchHistory addSubview:tagList];
    
    
}
@end
