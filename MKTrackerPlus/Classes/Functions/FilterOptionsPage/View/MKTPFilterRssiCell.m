//
//  MKTPFilterRssiCell.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/29.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPFilterRssiCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKSlider.h"
#import "MKCustomUIAdopter.h"

static NSString *const noteMsg = @"*The Tracker will store valid ADV data with RSSI no less than 0dBm.";

@implementation MKTPFilterRssiCellModel
@end

@interface MKTPFilterRssiCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKSlider *intervalSlider;

@property (nonatomic, strong)UILabel *intervalLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKTPFilterRssiCell

+ (MKTPFilterRssiCell *)initCellWithTableView:(UITableView *)tableView {
    MKTPFilterRssiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTPFilterRssiCellIdenty"];
    if (!cell) {
        cell = [[MKTPFilterRssiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKTPFilterRssiCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.intervalSlider];
        [self.contentView addSubview:self.intervalLabel];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.intervalSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.intervalLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.intervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.intervalSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    CGSize size = [NSString sizeWithText:noteMsg
                                 andFont:MKFont(12.f)
                              andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(-15.f);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - event method
- (void)intervalSliderValueChanged {
    if ([self.delegate respondsToSelector:@selector(mk_fliterRssiValueChanged:)]) {
        NSString *value = [NSString stringWithFormat:@"%.f",self.intervalSlider.value];
        [self.delegate mk_fliterRssiValueChanged:[value integerValue]];
    }
    [self updateUI];
}

#pragma mark - setter
- (void)setDataModel:(MKTPFilterRssiCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.intervalSlider.value = _dataModel.rssi;
    [self updateUI];
}

#pragma mark - private method
- (void)updateUI {
    NSString *value = [NSString stringWithFormat:@"%.fdBm",self.intervalSlider.value];
    if ([value isEqualToString:@"-0dBm"]) {
        value = @"0dBm";
    }
    self.intervalLabel.text = value;
    self.noteLabel.text = [NSString stringWithFormat:@"%@%@.",@"*The Tracker will store valid ADV data with RSSI no less than ",value];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"RSSI Filter",@"   (-127dBm ~ 0dBm)"] fonts:@[MKFont(15.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _msgLabel;
}

- (MKSlider *)intervalSlider {
    if (!_intervalSlider) {
        _intervalSlider = [[MKSlider alloc] init];
        _intervalSlider.maximumValue = 0.f;
        _intervalSlider.minimumValue = -127.f;
        _intervalSlider.value = 0.f;
        [_intervalSlider addTarget:self
                            action:@selector(intervalSliderValueChanged)
                  forControlEvents:UIControlEventValueChanged];
    }
    return _intervalSlider;
}

- (UILabel *)intervalLabel {
    if (!_intervalLabel) {
        _intervalLabel = [[UILabel alloc] init];
        _intervalLabel.textColor = DEFAULT_TEXT_COLOR;
        _intervalLabel.textAlignment = NSTextAlignmentLeft;
        _intervalLabel.font = MKFont(11.f);
        _intervalLabel.text = @"0 dBm";
    }
    return _intervalLabel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.textColor = RGBCOLOR(193, 88, 38);
        _noteLabel.text = noteMsg;
        _noteLabel.numberOfLines = 0;
        _noteLabel.font = MKFont(12.f);
    }
    return _noteLabel;
}

@end
