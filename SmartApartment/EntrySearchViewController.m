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


@property(nonatomic,strong)NSArray *searchRecord;

@property(nonatomic,strong)NSMutableArray *searchType;
@property(nonatomic,strong)NSMutableArray *searchContent;
@property(nonatomic,strong)NSMutableDictionary *searchDic;

@end

@implementation EntrySearchViewController
{
    GBTagListView *tagView;
    SearchTypeView *searchTypeView;
}

-(NSMutableDictionary *)searchDic{
    if (!_searchDic) {
        _searchDic = [NSMutableDictionary dictionary];
        [_searchDic setObject:@"0" forKey:@"searchType"];
    }
    return _searchDic;
}

-(NSArray *)searchRecord{
    if (!_searchRecord) {
        _searchRecord = [NSArray array];
    }
    return _searchRecord;
}

-(NSMutableArray *)searchContent{
    if (!_searchContent) {
        _searchContent = [NSMutableArray array];
    }
    return _searchContent;
}

-(NSMutableArray *)searchType{
    if (!_searchType) {
        _searchType = [NSMutableArray array];
    }
    return _searchType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.cornerRadius = 8;
    
    NSString *searchString = [ModelTool find_UserData].searchRecord;
    self.searchRecord = [searchString componentsSeparatedByString:@","];
    for (NSString *record in self.searchRecord) {
        NSArray *recordStr = [record componentsSeparatedByString:@"|"];
        [self.searchContent addObject:recordStr[0]];
        [self.searchType addObject:recordStr[1]];
    }
    
    self.navigationController.navigationBar.hidden = YES;
    tagView = [[GBTagListView alloc] init];
    tagView.frame = CGRectMake(0, 0, self.scrollView.width, 0);
    tagView.canTouch = YES;
    tagView.isSingleSelect = YES;
    tagView.isSearch = YES;
    tagView.signalTagColor = [UIColor whiteColor];
    [tagView setTagWithSearchType:self.searchContent];
    __weak  typeof(self) weakself = self;
    [tagView setDidselectItemBlock:^(NSArray * arr) {
        if (arr.count>0) {
             weakself.searchTextField.text = arr[0];
            [weakself.searchDic setObject:weakself.searchTextField.text forKey:@"searchContent"];
            for (int i = 0; i <weakself.searchContent.count; i++) {
                NSString *content  = weakself.searchContent[i];
                if ([content isEqualToString:arr[0]]) {
                    [weakself.searchDic setObject:weakself.searchType[i] forKey:@"searchType"];
                
                }
            }
            
          
            [weakself.delegate passValue:weakself.searchDic];
            [weakself.navigationController popViewControllerAnimated:YES];
            
            
            
            
        }else{
            weakself.searchTextField.text = @"";
        }
    }];
    [self.scrollView addSubview:tagView];
    [self.scrollView setContentSize:CGSizeMake(0, tagView.height)];
    searchTypeView = [[NSBundle mainBundle] loadNibNamed:@"SearchTypeView" owner:self options:nil][0];
    searchTypeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.79f];
    [self.view addSubview:searchTypeView];
    searchTypeView.x = self.contentView.x;
    searchTypeView.y = self.contentView.y+55;
    searchTypeView.height = 0;
    searchTypeView.hidden = YES;
    [self.searchDic setObject:@"0" forKey:@"searchType"];
    [searchTypeView.searchRenter addTarget:self action:@selector(clickSearchName) forControlEvents:UIControlEventTouchUpInside];
    [searchTypeView.searchRoom addTarget:self action:@selector(clickRoomNumber) forControlEvents:UIControlEventTouchUpInside];
}


/**
 点击了搜索租客
 */
-(void)clickSearchName{
    self.searchTextField.placeholder = @"请输入租客名/手机";
    [self.searchTypeBtn setTitle:@"租客" forState:UIControlStateNormal];
    [self.searchDic setObject:@"0" forKey:@"searchType"];
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
    [self.searchDic setObject:@"1" forKey:@"searchType"];
    [UIView animateWithDuration:0.25f animations:^{
        searchTypeView.height = 0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        searchTypeView.hidden = YES;
    });
}

/**
 点击展示搜索类型
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
        [MBProgressHUD showMessage:@"请输入搜索内容"];
        return;
    }
    NSString *searchString = [ModelTool find_UserData].searchRecord;
    if (searchString.length == 0) {
        searchString = [NSString stringWithFormat:@"%@|%@",self.searchTextField.text,[self.searchDic objectForKey:@"searchType"]];
    }else{
       searchString= [searchString stringByAppendingString:@","];
       searchString= [searchString stringByAppendingString:[NSString stringWithFormat:@"%@|%@",self.searchTextField.text,[self.searchDic objectForKey:@"searchType"]]];
    }
    if ([ModelTool find_UserData].searchRecord.length == 0) {
            [ModelTool find_UserData].searchRecord = searchString;
    }
    for (int i = 0; i <self.searchRecord.count; i++) {
        NSString *string = self.searchRecord[i];
        if (![string isEqualToString:[searchString stringByAppendingString:[NSString stringWithFormat:@"%@|%@",self.searchTextField.text,[self.searchDic objectForKey:@"searchType"]]]]) {
            [ModelTool find_UserData].searchRecord = searchString;
        }
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSManagedObjectContext *privateContext= [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
        [privateContext MR_saveToPersistentStoreAndWait];
    });
    
    [self.searchDic setObject:self.searchTextField.text forKey:@"searchContent"];
    [self.delegate passValue:self.searchDic];
    [self.navigationController popViewControllerAnimated:YES];

    
}


- (IBAction)clickToCleanHirstory:(id)sender {
    [ModelTool find_UserData].searchRecord=@"";
    NSManagedObjectContext *privateContext= [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
    [privateContext MR_saveToPersistentStoreAndWait];
    
    for (UIButton *btn in tagView.subviews) {
        [btn removeFromSuperview];
    }
}


/**
 返回到上一个界面

 */
- (IBAction)click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

@end
