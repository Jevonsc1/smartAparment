//
//  EntrySearchViewController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/13.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "EntrySearchViewController.h"
#import "GBTagListView.h"
#import "SearchTypeView.h"

@interface EntrySearchViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *searchTypeBtn;

@end

@implementation EntrySearchViewController
{
    GBTagListView *tagView;
    //搜索记录
    NSArray *searchRecord;
    NSMutableArray *searchType;
    NSMutableArray *searchContent;
    //用户数据
    UserData *userdata;
    //筛选租客或房间的黑色view
    SearchTypeView *searchTypeView;
    //返回搜索的参数
    NSMutableDictionary *searchDic;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.cornerRadius = 8;
    searchDic = [NSMutableDictionary dictionaryWithCapacity:0];
    searchType = [NSMutableArray arrayWithCapacity:0];
    searchContent = [NSMutableArray arrayWithCapacity:0];
    [searchDic setObject:@"0" forKey:@"searchType"];
    userdata = [ModelTool find_UserData];
    NSString *searchString = userdata.searchRecord;
    searchRecord = [searchString componentsSeparatedByString:@","];
    for (NSString *record in searchRecord) {
        NSArray *recordStr = [record componentsSeparatedByString:@"|"];
        [searchContent addObject:recordStr[0]];
        [searchType addObject:recordStr[1]];
    }
    
    self.navigationController.navigationBar.hidden = YES;
    tagView = [[GBTagListView alloc] init];
    tagView.frame = CGRectMake(0, 0, self.scrollView.width, 0);
    tagView.canTouch = YES;
    tagView.isSingleSelect = YES;
    tagView.isSearch = YES;
    tagView.signalTagColor = [UIColor whiteColor];
    [tagView setTagWithSearchType:searchContent];
    __block EntrySearchViewController *blockSelf = self;
    [tagView setDidselectItemBlock:^(NSArray * arr) {
        if (arr.count>0) {
             blockSelf->_searchTextField.text = arr[0];
            [blockSelf->searchDic setObject:blockSelf->_searchTextField.text forKey:@"searchContent"];
            for (int i = 0; i <blockSelf->searchContent.count; i++) {
                NSString *content  = blockSelf->searchContent[i];
                if ([content isEqualToString:arr[0]]) {
                    [blockSelf->searchDic setObject:blockSelf->searchType[i] forKey:@"searchType"];
                
                }
            }
            
          
            [blockSelf->_delegate passValue:blockSelf->searchDic];
            [blockSelf.navigationController popViewControllerAnimated:YES];
            
            
            
            
        }else{
            blockSelf->_searchTextField.text = @"";
        }
    }];
    [self.scrollView addSubview:tagView];
    [self.scrollView setContentSize:CGSizeMake(0, tagView.height)];
    searchTypeView = [[NSBundle mainBundle] loadNibNamed:@"EntrySearchXib" owner:self options:nil][0];
    searchTypeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.79f];
    [self.view addSubview:searchTypeView];
    searchTypeView.x = self.contentView.x;
    searchTypeView.y = self.contentView.y+55;
    searchTypeView.height = 0;
    searchTypeView.hidden = YES;
    [searchDic setObject:@"0" forKey:@"searchType"];
    [searchTypeView.searchRenter addTarget:self action:@selector(clickSearchName) forControlEvents:UIControlEventTouchUpInside];
    [searchTypeView.searchRoom addTarget:self action:@selector(clickRoomNumber) forControlEvents:UIControlEventTouchUpInside];
}


/**
 点击了搜索租客
 */
-(void)clickSearchName{
    self.searchTextField.placeholder = @"请输入租客名/手机";
    [self.searchTypeBtn setTitle:@"租客" forState:UIControlStateNormal];
    [searchDic setObject:@"0" forKey:@"searchType"];
    [UIView animateWithDuration:0.25f animations:^{
        searchTypeView.height = 0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        searchTypeView.hidden = YES;
    });
}


/**
 点击了搜索房间
 */
-(void)clickRoomNumber{
    self.searchTextField.placeholder = @"请输入公寓名/房间号";
    [self.searchTypeBtn setTitle:@"房间" forState:UIControlStateNormal];
    [searchDic setObject:@"1" forKey:@"searchType"];
    [UIView animateWithDuration:0.25f animations:^{
        searchTypeView.height = 0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        searchTypeView.hidden = YES;
    });
}

/**
 点击展示搜索类型

 @param sender
 */
- (IBAction)clickToShowSearchType:(UIButton *)sender {
    if (sender.tag == 1) {
        searchTypeView.hidden = NO;
        [UIView animateWithDuration:0.25f animations:^{
            searchTypeView.height = 62;
        }];
        sender.tag = 2;
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            searchTypeView.hidden = YES;
        });
        [UIView animateWithDuration:0.25f animations:^{
            searchTypeView.height = 0;
        }];
        sender.tag = 1;
    }
}


- (IBAction)clickToSearch:(id)sender {
    if (self.searchTextField.text.length <=0) {
        [Alert showFail:@"请输入搜索内容" View:self.view andTime:1.5 complete:nil];
        return;
    }
    NSString *searchString = userdata.searchRecord;
    if (searchString.length == 0) {
        searchString = [NSString stringWithFormat:@"%@|%@",self.searchTextField.text,[searchDic objectForKey:@"searchType"]];
    }else{
       searchString= [searchString stringByAppendingString:@","];
       searchString= [searchString stringByAppendingString:[NSString stringWithFormat:@"%@|%@",self.searchTextField.text,[searchDic objectForKey:@"searchType"]]];
    }
    if (userdata.searchRecord.length == 0) {
            userdata.searchRecord = searchString;
    }
    for (int i = 0; i <searchRecord.count; i++) {
        NSString *string = searchRecord[i];
        if (![string isEqualToString:[searchString stringByAppendingString:[NSString stringWithFormat:@"%@|%@",self.searchTextField.text,[searchDic objectForKey:@"searchType"]]]]) {
            userdata.searchRecord = searchString;
        }
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSManagedObjectContext *privateContext= [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
        [privateContext MR_saveToPersistentStoreAndWait];
    });
    [searchDic setObject:self.searchTextField.text forKey:@"searchContent"];
    [self.delegate passValue:searchDic];
    [self.navigationController popViewControllerAnimated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)clickToCleanHirstory:(id)sender {
    userdata = [ModelTool find_UserData];
    userdata.searchRecord=@"";
    NSManagedObjectContext *privateContext= [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
    [privateContext MR_saveToPersistentStoreAndWait];
    
    for (UIButton *btn in tagView.subviews) {
        [btn removeFromSuperview];
    }
}


/**
 返回到上一个界面

 @param sender
 */
- (IBAction)click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

@end
