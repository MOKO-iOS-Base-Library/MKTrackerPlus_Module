//
//  MKTPFilterOptionsController.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/29.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPFilterOptionsController.h"

#import "MLInputDodger.h"

#import "Masonry.h"
#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "MKHudManager.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKFilterDataCell.h"

#import "MKTPFilterOptionsModel.h"
#import "MKTPFilterRssiCell.h"

static CGFloat const statusOnHeight = 145.f;
static CGFloat const statusOffHeight = 60.f;

@interface MKTPFilterOptionsController ()<UITableViewDelegate,
UITableViewDataSource,
MKTPFilterRssiCellDelegate,
MKFilterDataCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)UISwitch *footerSwitch;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)MKTPFilterOptionsModel *dataModel;

@end

@implementation MKTPFilterOptionsController

- (void)dealloc {
    NSLog(@"MKTPFilterOptionsController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [self startReadDatas];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startConfigDataWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Saved Successfully!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadCellHeightWithIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTPFilterRssiCell *cell = [MKTPFilterRssiCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKFilterDataCell *cell = [MKFilterDataCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTPFilterRssiCellDelegate
- (void)mk_fliterRssiValueChanged:(NSInteger)rssi {
    self.dataModel.rssiValue = rssi;
    MKTPFilterRssiCellModel *rssiModel = self.section0List[0];
    rssiModel.rssi = rssi;
}

#pragma mark - MKFilterDataCellDelegate

/// 顶部开关状态发生改变
/// @param isOn 开关状态
/// @param index 当前cell所在index
- (void)mk_fliterSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        self.dataModel.macIson = isOn;
    }else if (index == 1) {
        self.dataModel.advNameIson = isOn;
    }else if (index == 2) {
        self.dataModel.uuidIson = isOn;
    }else if (index == 3) {
        self.dataModel.majorIson = isOn;
    }else if (index == 4) {
        self.dataModel.minorIson = isOn;
    }else if (index == 5) {
        self.dataModel.rawDataIson = isOn;
    }
    MKFilterDataCellModel *cellModel = self.section1List[index];
    cellModel.isOn = isOn;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)mk_listButtonStateChanged:(BOOL)selected index:(NSInteger)index {
    if (index == 0) {
        self.dataModel.macWhiteListIson = selected;
    }else if (index == 1) {
        self.dataModel.advNameWhiteListIson = selected;
    }else if (index == 2) {
        self.dataModel.uuidWhiteListIson = selected;
    }else if (index == 3) {
        self.dataModel.majorWhiteListIson = selected;
    }else if (index == 4) {
        self.dataModel.minorWhiteListIson = selected;
    }else if (index == 5) {
        self.dataModel.rawDataWhiteListIson = selected;
    }
    MKFilterDataCellModel *cellModel = self.section1List[index];
    cellModel.selected = selected;
}

/// mk_filterDataCellType==mk_filterDataCellType_normal的情况下输入框内容发生改变
/// @param value 当前textField的值
/// @param index 当前cell所在index
- (void)mk_filterTextFieldValueChanged:(NSString *)value index:(NSInteger)index {
    if (index == 0) {
        self.dataModel.macValue = value;
    }else if (index == 1) {
        self.dataModel.advNameValue = value;
    }else if (index == 2) {
        self.dataModel.uuidValue = value;
    }else if (index == 5) {
        self.dataModel.rawDataValue = value;
    }
    MKFilterDataCellModel *cellModel = self.section1List[index];
    cellModel.textFieldValue = value;
}

/// mk_filterDataCellType==mk_filterDataCellType_double的情况下左侧输入框内容发生改变
/// @param value 当前textField的值
/// @param index 当前cell所在index
- (void)mk_leftFilterTextFieldValueChanged:(NSString *)value index:(NSInteger)index {
    if (index == 3) {
        self.dataModel.majorMinValue = value;
    }else if (index == 4) {
        self.dataModel.minorMinValue = value;
    }
    MKFilterDataCellModel *cellModel = self.section1List[index];
    cellModel.leftTextFieldValue = value;
}

/// mk_filterDataCellType==mk_filterDataCellType_double的情况下右侧输入框内容发生改变
/// @param value 当前textField的值
/// @param index 当前cell所在index
- (void)mk_rightFilterTextFieldValueChanged:(NSString *)value index:(NSInteger)index {
    if (index == 3) {
        self.dataModel.majorMaxValue = value;
    }else if (index == 4) {
        self.dataModel.minorMaxValue = value;
    }
    MKFilterDataCellModel *cellModel = self.section1List[index];
    cellModel.rightTextFieldValue = value;
}

#pragma mark - event method
- (void)filterAdvStateValueChanged {
    self.dataModel.advDataFilterIson = self.footerSwitch.isOn;
}

#pragma mark - interface
- (void)startReadDatas {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startReadDataWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.footerSwitch setOn:weakSelf.dataModel.advDataFilterIson];
        [weakSelf updateCellValues];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellValues {
    //section0
    MKTPFilterRssiCellModel *rssiModel = self.section0List[0];
    rssiModel.rssi = self.dataModel.rssiValue;
    
    //section1
    MKFilterDataCellModel *macModel = self.section1List[0];
    macModel.isOn = self.dataModel.macIson;
    macModel.selected = self.dataModel.macWhiteListIson;
    macModel.textFieldValue = self.dataModel.macValue;
    
    MKFilterDataCellModel *advNameModel = self.section1List[1];
    advNameModel.isOn = self.dataModel.advNameIson;
    advNameModel.selected = self.dataModel.advNameWhiteListIson;
    advNameModel.textFieldValue = self.dataModel.advNameValue;
    
    MKFilterDataCellModel *uuidModel = self.section1List[2];
    uuidModel.isOn = self.dataModel.uuidIson;
    uuidModel.selected = self.dataModel.uuidWhiteListIson;
    uuidModel.textFieldValue = self.dataModel.uuidValue;
    
    MKFilterDataCellModel *majorModel = self.section1List[3];
    majorModel.isOn = self.dataModel.majorIson;
    majorModel.selected = self.dataModel.majorWhiteListIson;
    majorModel.leftTextFieldValue = self.dataModel.majorMinValue;
    majorModel.rightTextFieldValue = self.dataModel.majorMaxValue;
    
    MKFilterDataCellModel *minorModel = self.section1List[4];
    minorModel.isOn = self.dataModel.minorIson;
    minorModel.selected = self.dataModel.minorWhiteListIson;
    minorModel.leftTextFieldValue = self.dataModel.minorMinValue;
    minorModel.rightTextFieldValue = self.dataModel.minorMaxValue;
    
    MKFilterDataCellModel *advDataModel = self.section1List[5];
    advDataModel.isOn = self.dataModel.rawDataIson;
    advDataModel.selected = self.dataModel.rawDataWhiteListIson;
    advDataModel.textFieldValue = self.dataModel.rawDataValue;
    
    [self.tableView reloadData];
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    [self.section0List removeAllObjects];
    MKTPFilterRssiCellModel *cellModel = [[MKTPFilterRssiCellModel alloc] init];
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    
    MKFilterDataCellModel *macModel = [[MKFilterDataCellModel alloc] init];
    macModel.index = 0;
    macModel.msg = @"MAC Address Filtering";
    macModel.textFieldPlaceholder = @"1 ~ 6 Bytes";
    macModel.textFieldType = mk_hexCharOnly;
    macModel.maxLength = 12;
    [self.section1List addObject:macModel];
    
    MKFilterDataCellModel *advNameModel = [[MKFilterDataCellModel alloc] init];
    advNameModel.index = 1;
    advNameModel.msg = @"BLE Name Filtering";
    advNameModel.textFieldPlaceholder = @"1 ~ 10 Characters";
    advNameModel.textFieldType = mk_normal;
    advNameModel.maxLength = 10;
    [self.section1List addObject:advNameModel];
    
    MKFilterDataCellModel *uuidModel = [[MKFilterDataCellModel alloc] init];
    uuidModel.index = 2;
    uuidModel.msg = @"iBeacon UUID Filtering";
    uuidModel.textFieldPlaceholder = @"16 Bytes";
    uuidModel.textFieldType = mk_uuidMode;
    [self.section1List addObject:uuidModel];
    
    MKFilterDataCellModel *majorModel = [[MKFilterDataCellModel alloc] init];
    majorModel.index = 3;
    majorModel.msg = @"iBeacon Major Filtering";
    majorModel.cellType = mk_filterDataCellType_double;
    [self.section1List addObject:majorModel];
    
    MKFilterDataCellModel *minorModel = [[MKFilterDataCellModel alloc] init];
    minorModel.index = 4;
    minorModel.msg = @"iBeacon Minor Filtering";
    minorModel.cellType = mk_filterDataCellType_double;
    [self.section1List addObject:minorModel];
    
    MKFilterDataCellModel *advDataModel = [[MKFilterDataCellModel alloc] init];
    advDataModel.index = 5;
    advDataModel.msg = @"BLE Advertising Data Filtering";
    advDataModel.textFieldPlaceholder = @"1 ~ 29 Bytes";
    advDataModel.textFieldType = mk_hexCharOnly;
    advDataModel.maxLength = 58;
    [self.section1List addObject:advDataModel];
}

- (CGFloat)loadCellHeightWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 95.f;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return (self.dataModel.macIson ? statusOnHeight : statusOffHeight);
        }
        if (indexPath.row == 1) {
            return (self.dataModel.advNameIson ? statusOnHeight : statusOffHeight);
        }
        if (indexPath.row == 2) {
            return (self.dataModel.uuidIson ? statusOnHeight : statusOffHeight);
        }
        if (indexPath.row == 3) {
            return (self.dataModel.majorIson ? statusOnHeight : statusOffHeight);
        }
        if (indexPath.row == 4) {
            return (self.dataModel.minorIson ? statusOnHeight : statusOffHeight);
        }
        if (indexPath.row == 5) {
            return (self.dataModel.rawDataIson ? statusOnHeight : statusOffHeight);
        }
    }
    return 0.f;
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"FILTERING OPTIONS";
    [self.rightButton setImage:LOADICON(@"MKTrackerPlus", @"MKTPAdvertiserController", @"tp_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [self tableFooterView];
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (MKTPFilterOptionsModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKTPFilterOptionsModel alloc] init];
    }
    return _dataModel;
}

- (UISwitch *)footerSwitch {
    if (!_footerSwitch) {
        _footerSwitch = [[UISwitch alloc] init];
        [_footerSwitch addTarget:self
                          action:@selector(filterAdvStateValueChanged)
                forControlEvents:UIControlEventValueChanged];
    }
    return _footerSwitch;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 130.f)];
    footerView.backgroundColor = COLOR_WHITE_MACROS;
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 5.f, 150.f, 45.f)];
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.font = MKFont(15.f);
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.text = @"All BLE Devices";
    [footerView addSubview:msgLabel];
    
    self.footerSwitch.frame = CGRectMake(kViewWidth - 15.f - 50.f, 5.f, 50.f, 45.f);
    [footerView addSubview:self.footerSwitch];
    
    NSString *noteMsg = @"*Turn on All BLE Devices, the Tracker will store all types of BLE advertising data. Turn off this option, the Tracker will store the corresponding advertising data according to other filtering rules.";
    CGSize noteSize = [NSString sizeWithText:noteMsg
                                     andFont:MKFont(12.f)
                                  andMaxSize:CGSizeMake(kViewWidth - 30.f, MAXFLOAT)];
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 55.f, kViewWidth - 30.f, noteSize.height)];
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.textColor = RGBCOLOR(193, 88, 38);
    noteLabel.text = noteMsg;
    noteLabel.numberOfLines = 0;
    noteLabel.font = MKFont(12.f);
    [footerView addSubview:noteLabel];
    
    return footerView;
}

@end
