//
//  TDMyDoorCardListTableViewCell.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/6.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDMyDoorCardListTableViewCell.h"

@interface TDMyDoorCardListTableViewCell ()

@property (strong, nonatomic) UIImageView *typeImageView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *statusButton;
@property (strong, nonatomic) UILabel *statusPromptLabel;
@end

@implementation TDMyDoorCardListTableViewCell

- (void)setCardType:(DoorCardType)cardType {
    switch (cardType) {
        case DoorCardTypeMobile:
        {
            [_typeImageView setImage:[UIImage imageNamed:@"Mobile"]];
            [_titleLabel setText:@"手机开门"];
        }
            break;
        case DoorCardTypeICCard:
        {
            [_typeImageView setImage:[UIImage imageNamed:@"ICCard"]];
            [_titleLabel setText:@"IC 卡开门"];
        }
            break;
        case DoorCardTypeIDCard:
        {
            [_typeImageView setImage:[UIImage imageNamed:@"IDCard"]];
            [_titleLabel setText:@"身份证开门"];
        }
            break;
        default:
            break;
    }
}

- (void)setStatus:(NSInteger)status {
    [_reopeningButton setHidden:YES];
    [_reportTheLossButton setHidden:YES];
    [_reportTheLossButton setTitle:@"挂失" forState:UIControlStateNormal];
    [_detailsButton setHidden:YES];
    
    switch (status) {
        case 1:// 1启用
        {
            [_statusButton setHidden:NO];
            [_statusButton setImage:[UIImage imageNamed:@"启用"] forState:UIControlStateNormal];
            [_statusButton setTitle:@"正常启用" forState:UIControlStateNormal];
            [_statusButton setTitleColor:RGB(102, 177, 79) forState:UIControlStateNormal];
            
            [_statusPromptLabel setHidden:YES];
            
            if ([[_titleLabel text] isEqualToString:@"IC 卡开门"]) {
                [_reopeningButton setHidden:NO];
                [_reopeningButton setFrame:CGRectMake(17, 47, 80, 26)];
                [_reopeningButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
                [_reopeningButton cornerRadius:3 color:RGB(187, 187, 187)];
                [_reportTheLossButton setHidden:NO];
                [_reportTheLossButton setFrame:CGRectMake((SCREEN_WIDTH-80)/2, 47, 80, 26)];
                [_reportTheLossButton setTitleColor:RGB(46, 126, 224) forState:UIControlStateNormal];
                [_reportTheLossButton cornerRadius:3 color:RGB(46, 126, 224)];
                [_detailsButton setHidden:NO];
                [_detailsButton setFrame:CGRectMake(SCREEN_WIDTH-80-17, 47, 80, 26)];
            }
        }
            break;
        case 2:// 2未启用
        {
            [_statusButton setHidden:YES];
            [_statusPromptLabel setHidden:NO];
            [_statusPromptLabel setFrame:CGRectMake(SCREEN_WIDTH-160-17, 14, 160, 22)];
            [_statusPromptLabel setFont:[UIFont systemFontOfSize:16]];
            [_statusPromptLabel setText:@"未开启"];
        }
            break;
        case 3:// 3禁用
        {
            [_statusButton setHidden:NO];
            [_statusButton setImage:[UIImage imageNamed:@"禁用"] forState:UIControlStateNormal];
            [_statusButton setTitle:@"已禁用" forState:UIControlStateNormal];
            [_statusButton setTitleColor:RGB(229, 89, 89) forState:UIControlStateNormal];
            
            [_statusPromptLabel setHidden:NO];
            [_statusPromptLabel setFrame:CGRectMake(SCREEN_WIDTH-160-17, 40, 160, 22)];
            [_statusPromptLabel setFont:[UIFont systemFontOfSize:14]];
            
            if ([[_titleLabel text] isEqualToString:@"IC 卡开门"]) {
                [_reopeningButton setHidden:NO];
                [_reopeningButton setFrame:CGRectMake(17, 67, 80, 26)];
                [_reopeningButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
                [_reopeningButton cornerRadius:3 color:RGB(187, 187, 187)];
                [_reportTheLossButton setHidden:NO];
                [_reportTheLossButton setFrame:CGRectMake((SCREEN_WIDTH-80)/2, 67, 80, 26)];
                [_reportTheLossButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
                [_reportTheLossButton cornerRadius:3 color:RGB(187, 187, 187)];
                [_detailsButton setHidden:NO];
                [_detailsButton setFrame:CGRectMake(SCREEN_WIDTH-80-17, 67, 80, 26)];
            }
        }
            break;
        case 4:// 4挂失
        {
            [_statusButton setHidden:YES];
            [_statusPromptLabel setHidden:NO];
            [_statusPromptLabel setFrame:CGRectMake(SCREEN_WIDTH-160-17, 14, 160, 22)];
            [_statusPromptLabel setFont:[UIFont systemFontOfSize:16]];
            [_statusPromptLabel setText:@"已挂失"];
            
            if ([[_titleLabel text] isEqualToString:@"IC 卡开门"]) {
                [_reopeningButton setHidden:NO];
                [_reopeningButton setFrame:CGRectMake(17, 47, 80, 26)];
                [_reopeningButton setTitleColor:RGB(46, 126, 224) forState:UIControlStateNormal];
                [_reopeningButton cornerRadius:3 color:RGB(46, 126, 224)];
                [_reportTheLossButton setHidden:NO];
                [_reportTheLossButton setFrame:CGRectMake((SCREEN_WIDTH-80)/2, 47, 80, 26)];
                [_reportTheLossButton setTitleColor:RGB(46, 126, 224) forState:UIControlStateNormal];
                [_reportTheLossButton setTitle:@"取消挂失" forState:UIControlStateNormal];
                [_reportTheLossButton cornerRadius:3 color:RGB(46, 126, 224)];
                [_detailsButton setHidden:NO];
                [_detailsButton setFrame:CGRectMake(SCREEN_WIDTH-80-17, 47, 80, 26)];
            }
        }
            break;
        case 5:// 5敬请期待
        {
            [_statusButton setHidden:YES];
            [_statusPromptLabel setHidden:NO];
            [_statusPromptLabel setFrame:CGRectMake(SCREEN_WIDTH-160-17, 14, 160, 22)];
            [_statusPromptLabel setFont:[UIFont systemFontOfSize:16]];
            [_statusPromptLabel setText:@"敬请期待"];
        }
            break;
        default:
            break;
    }
}

- (void)setPrompt:(NSString *)prompt {
    [_statusPromptLabel setText:prompt];
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    [super setAccessoryType:accessoryType];
    
    CGRect frame = _statusPromptLabel.frame;
    if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        frame.origin.x = SCREEN_WIDTH-160-36;
    }else {
        frame.origin.x = SCREEN_WIDTH-160-17;
    }
    [_statusPromptLabel setFrame:frame];
}

- (void)setup {
    _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 22, 22)];
    [self addSubview:_typeImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 14, 100, 22)];
    [_titleLabel setTextColor:RGB(51, 51, 51)];
    [_titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:_titleLabel];
    
    _statusButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100-17, 14, 100, 22)];
    [_statusButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_statusButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self addSubview:_statusButton];
    
    _statusPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100-17, 14, 100, 22)];
    [_statusPromptLabel setTextColor:RGB(136, 136, 136)];
    [_statusPromptLabel setTextAlignment:NSTextAlignmentRight];
    [_statusPromptLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:_statusPromptLabel];
    
    _reopeningButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 47, 80, 26)];
    [_reopeningButton setTitle:@"重新开通" forState:UIControlStateNormal];
    [_reopeningButton setTitleColor:RGB(46, 126, 224) forState:UIControlStateNormal];
    [_reopeningButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_reopeningButton setTag:0];
    [_reopeningButton setHidden:YES];
    [_reopeningButton cornerRadius:3 color:RGB(46, 126, 224)];
    [self addSubview:_reopeningButton];
    
    _reportTheLossButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 47, 80, 26)];
    [_reportTheLossButton setTitle:@"挂失" forState:UIControlStateNormal];
    [_reportTheLossButton setTitleColor:RGB(46, 126, 224) forState:UIControlStateNormal];
    [_reportTheLossButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_reportTheLossButton setTag:1];
    [_reportTheLossButton setHidden:YES];
    [_reportTheLossButton cornerRadius:3 color:RGB(46, 126, 224)];
    [self addSubview:_reportTheLossButton];
    
    _detailsButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80-17, 47, 80, 26)];
    [_detailsButton setTitle:@"详情" forState:UIControlStateNormal];
    [_detailsButton setTitleColor:RGB(46, 126, 224) forState:UIControlStateNormal];
    [_detailsButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_detailsButton setTag:2];
    [_detailsButton setHidden:YES];
    [_detailsButton cornerRadius:3 color:RGB(46, 126, 224)];
    [self addSubview:_detailsButton];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
