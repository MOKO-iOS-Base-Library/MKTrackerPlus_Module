//
//  MKTextSwitchCell.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/22.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTextSwitchCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKTextSwitchCellModel
@end

@interface MKTextSwitchCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UISwitch *switchView;

@end

@implementation MKTextSwitchCell

+ (MKTextSwitchCell *)initCellWithTableView:(UITableView *)tableView {
    MKTextSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTextSwitchCellIdenty"];
    if (!cell) {
        cell = [[MKTextSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKTextSwitchCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchView];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.leftIcon) {
        //左侧有图标
        UIImage *image = self.leftIcon.image;
        [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.width.mas_equalTo(image.size.width);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(image.size.height);
        }];
    }
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.leftIcon) {
            make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(3.f);
        }else{
            make.left.mas_equalTo(15.f);
        }
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-1.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(self.contentView.mas_height);
    }];
    [self.switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - Private method
- (void)switchViewValueChanged{
    if ([self.delegate respondsToSelector:@selector(mk_textSwitchCellStatusChanged:index:)]) {
        [self.delegate mk_textSwitchCellStatusChanged:self.switchView.isOn index:self.dataModel.index];
    }
}

#pragma mark - Public method
- (void)setDataModel:(MKTextSwitchCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.msgLabel.font = (_dataModel.msgFont ? _dataModel.msgFont : MKFont(15.f));
    self.msgLabel.textColor = (_dataModel.msgColor ? _dataModel.msgColor : DEFAULT_TEXT_COLOR);
    [self.switchView setOn:_dataModel.isOn];
    if (self.leftIcon && self.leftIcon.superview) {
        [self.leftIcon removeFromSuperview];
        self.leftIcon = nil;
    }
    if (_dataModel.leftIcon) {
        self.leftIcon = [[UIImageView alloc] init];
        self.leftIcon.image = _dataModel.leftIcon;
        [self.contentView addSubview:self.leftIcon];
    }
    [self setNeedsLayout];
}

#pragma mark - setter & getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UISwitch *)switchView{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.backgroundColor = COLOR_WHITE_MACROS;
        [_switchView addTarget:self
                        action:@selector(switchViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

@end
