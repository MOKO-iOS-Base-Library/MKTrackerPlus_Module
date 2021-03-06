//
//  MKTPTrackingIntervalCell.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPTrackingIntervalCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKSlider.h"
#import "MKCustomUIAdopter.h"

@implementation MKTPTrackingIntervalCellModel
@end

static NSString *const noteMsg = @"*The Tracker will no longer store the tracked data with the same MAC address within 1 min.";

@interface MKTPTrackingIntervalCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKSlider *intervalSlider;

@property (nonatomic, strong)UILabel *intervalLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKTPTrackingIntervalCell

+ (MKTPTrackingIntervalCell *)initCellWithTableView:(UITableView *)tableView {
    MKTPTrackingIntervalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTPTrackingIntervalCellIdenty"];
    if (!cell) {
        cell = [[MKTPTrackingIntervalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKTPTrackingIntervalCellIdenty"];
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
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(-5.f);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - event method
- (void)intervalSliderValueChanged {
    self.intervalLabel.text = [NSString stringWithFormat:@"%.f min",self.intervalSlider.value];
    self.noteLabel.text = [@"*The Tracker will no longer store the tracked data with the same MAC address within" stringByAppendingString:[NSString stringWithFormat:@" %@",self.intervalLabel.text]];
    if ([self.delegate respondsToSelector:@selector(mk_trackingIntervalValueChanged:)]) {
        [self.delegate mk_trackingIntervalValueChanged:[NSString stringWithFormat:@"%.f",self.intervalSlider.value]];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKTPTrackingIntervalCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.intervalSlider.value = [_dataModel.trackingInterval floatValue];
    self.intervalLabel.text = [NSString stringWithFormat:@"%.f min",self.intervalSlider.value];
    self.noteLabel.text = [@"*The Tracker will no longer store the tracked data with the same MAC address within" stringByAppendingString:[NSString stringWithFormat:@" %@",self.intervalLabel.text]];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Tracking Interval",@"   (0min ~ 100min)"] fonts:@[MKFont(15.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _msgLabel;
}

- (MKSlider *)intervalSlider {
    if (!_intervalSlider) {
        _intervalSlider = [[MKSlider alloc] init];
        _intervalSlider.maximumValue = 100.f;
        _intervalSlider.minimumValue = 0.f;
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
        _intervalLabel.text = @"0 min";
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
