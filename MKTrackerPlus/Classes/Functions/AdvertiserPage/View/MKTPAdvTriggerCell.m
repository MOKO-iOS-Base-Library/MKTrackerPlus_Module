//
//  MKTPAdvTriggerCell.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPAdvTriggerCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"
#import "MKTextField.h"

@implementation MKTPAdvTriggerCellModel
@end

@interface MKTPAdvTriggerCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UISwitch *switchView;

@property (nonatomic, strong)UIView *msgView;

@property (nonatomic, strong)UILabel *noteLabel1;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *noteLabel2;

@end

@implementation MKTPAdvTriggerCell

+ (MKTPAdvTriggerCell *)initCellWithTableView:(UITableView *)tableView {
    MKTPAdvTriggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTPAdvTriggerCellIdenty"];
    if (!cell) {
        cell = [[MKTPAdvTriggerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKTPAdvTriggerCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchView];
        [self.contentView addSubview:self.msgView];
        [self.msgView addSubview:self.noteLabel1];
        [self.msgView addSubview:self.textField];
        [self.msgView addSubview:self.noteLabel2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(150.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.width.mas_equalTo(45.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.switchView.mas_bottom).mas_offset(15.f);
        make.bottom.mas_equalTo(-CUTTING_LINE_HEIGHT);
    }];
    [self.noteLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(3.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.noteLabel1.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.noteLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_right).mas_offset(1.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(self.textField.mas_height);
    }];
}

#pragma mark - event method
- (void)switchViewValueChanged {
    self.msgView.hidden = !self.switchView.isOn;
    if ([self.delegate respondsToSelector:@selector(mk_advTriggerStatusChanged:)]) {
        [self.delegate mk_advTriggerStatusChanged:self.switchView.isOn];
    }
}

- (void)textFieldValueChanged:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(mk_advTriggerTimeChanged:)]) {
        [self.delegate mk_advTriggerTimeChanged:text];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKTPAdvTriggerCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    [self.switchView setOn:_dataModel.isOn];
    self.msgView.hidden = !_dataModel.isOn;
    self.textField.text = _dataModel.advTriggerTime;
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"ADV Trigger";
    }
    return _msgLabel;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self
                        action:@selector(switchViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIView *)msgView {
    if (!_msgView) {
        _msgView = [[UIView alloc] init];
        _msgView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _msgView;
}

- (UILabel *)noteLabel1 {
    if (!_noteLabel1) {
        _noteLabel1 = [[UILabel alloc] init];
        _noteLabel1.textColor = DEFAULT_TEXT_COLOR;
        _noteLabel1.font = MKFont(12.f);
        _noteLabel1.textAlignment = NSTextAlignmentLeft;
        _noteLabel1.text = @"The Beacon will stop advertising after static period of";
    }
    return _noteLabel1;
}

- (MKTextField *)textField {
    if (!_textField) {
        WS(weakSelf);
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            __strong typeof(self) sself = weakSelf;
            [sself textFieldValueChanged:text];
        };
        
        _textField.maxLength = 5;
        _textField.font = MKFont(12.f);
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.textAlignment = NSTextAlignmentCenter;
        UIView *tempLine = [[UIView alloc] init];
        tempLine.backgroundColor = DEFAULT_TEXT_COLOR;
        [_textField addSubview:tempLine];
        [tempLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.f);
        }];
    }
    return _textField;
}

- (UILabel *)noteLabel2 {
    if (!_noteLabel2) {
        _noteLabel2 = [[UILabel alloc] init];
        _noteLabel2.textAlignment = NSTextAlignmentLeft;
        _noteLabel2.attributedText = [MKCustomUIAdopter attributedString:@[@"(1~65535)",@" seconds"] fonts:@[MKFont(12.f),MKFont(12.f)] colors:@[RGBCOLOR(223, 223, 223),DEFAULT_TEXT_COLOR]];
    }
    return _noteLabel2;
}

@end
