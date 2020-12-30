//
//  MKTPTrackerConfigController.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPTrackerConfigController.h"

#import "Masonry.h"
#import "MLInputDodger.h"
#import "Toast.h"

#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "MKHudManager.h"
#import "UIView+MKAdd.h"
#import "MKTextButtonCell.h"
#import "MKNormalTextCell.h"

#import "MKTPDeviceTypeManager.h"

#import "MKTPTrackerConfigDataModel.h"
#import "MKTPScanWindowCell.h"
#import "MKTPTrackingIntervalCell.h"

#import "MKTPTrackerDataController.h"
#import "MKTPFilterOptionsController.h"

static NSString *const triggerNoteMsg = @"*The Tracker will stop tracking after static period of  0 seconds.Set to 0 seconds to turn off Tracking Trigger.";

@interface MKTPTrackerConfigController ()<UITableViewDelegate,
UITableViewDataSource,
MKTPScanWindowCellDelegate,
MKTPTrackingIntervalCellDelegate,
MKTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)MKTPTrackerConfigDataModel *dataModel;

@property (nonatomic, strong)UISwitch *trackingSwitch;

@end

@implementation MKTPTrackerConfigController

- (void)dealloc {
    NSLog(@"MKTPTrackerConfigController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    [self readDatasFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_tp_popToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    if (self.dataModel.scanStatus && [self.dataModel.scanWindow integerValue] > [self.dataModel.scanInterval integerValue]) {
        //扫描设置打开了，则扫描窗口时间不能大于扫描间隔
        [self.view makeToast:@"Save failed!The scan window value cannot be greater than the scan interval."
                    duration:2
                    position:CSToastPositionCenter
                       style:nil];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
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
    if (indexPath.section == 0) {
        return [MKTPScanWindowCell getCellHeight:(indexPath.row == 2 ? triggerNoteMsg : @"")];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        //Tracking Interval
        return 90.f;
    }
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        //
        MKTPFilterOptionsController *vc = [[MKTPFilterOptionsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
        //
        MKTPTrackerDataController *vc = [[MKTPTrackerDataController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (self.trackingSwitch.isOn ? self.section0List.count : 0);
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    return self.section4List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTPScanWindowCell *cell = [MKTPScanWindowCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 2) {
        MKTPTrackingIntervalCell *cell = [MKTPTrackingIntervalCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section4List[indexPath.row];
    return cell;
}

#pragma mark - MKTPScanWindowCellDelegate
- (void)mk_scanWindowParamsChanged:(NSString *)value index:(NSInteger)index {
    if (index == 0) {
        //scanWindow
        self.dataModel.scanWindow = value;
        return;
    }
    if (index == 1) {
        //scanInterval
        self.dataModel.scanInterval = value;
        return;
    }
    if (index == 2) {
        if ([MKTPDeviceTypeManager shared].supportAdvTrigger) {
            self.dataModel.trackingTrigger = value;
        }
    }
}

#pragma mark - MKTPTrackingIntervalCellDelegate
- (void)mk_trackingIntervalValueChanged:(NSString *)interval {
    self.dataModel.trackingInterval = interval;
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Tracking Notification
        self.dataModel.trackingNote = dataListIndex;
        return;
    }
    if (index == 1) {
        //Tracking Data Format
        self.dataModel.format = dataListIndex;
        return;
    }
}

#pragma mark - event method
- (void)switchViewValueChanged {
    self.dataModel.scanStatus = self.trackingSwitch.isOn;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startReadDataWithSucBlock:^{
        [[MKHudManager share] hide];
        weakSelf.trackingSwitch.on = weakSelf.dataModel.scanStatus;
        [self processSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)processSectionDatas {
    [self.trackingSwitch setOn:self.dataModel.scanStatus];
    
    MKTPScanWindowCellModel *scanWindowModel = self.section0List[0];
    scanWindowModel.textValue = self.dataModel.scanWindow;
    
    MKTPScanWindowCellModel *intervalModel = self.section0List[1];
    intervalModel.textValue = self.dataModel.scanInterval;
    
    if ([MKTPDeviceTypeManager shared].supportAdvTrigger) {
        MKTPScanWindowCellModel *triggerModel = self.section0List[2];
        triggerModel.textValue = self.dataModel.trackingTrigger;
    }
    
    MKTPTrackingIntervalCellModel *trackingIntervalModel = self.section2List[0];
    trackingIntervalModel.trackingInterval = self.dataModel.trackingInterval;
    
    MKTextButtonCellModel *noteModel = self.section3List[0];
    noteModel.dataListIndex = self.dataModel.trackingNote;
    
    MKTextButtonCellModel *formatModel = self.section3List[1];
    formatModel.dataListIndex = self.dataModel.format;
    
    [self.tableView reloadData];
}

#pragma mark - loadTableDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    [self.section0List removeAllObjects];
    
    MKTPScanWindowCellModel *scanWindowModel = [[MKTPScanWindowCellModel alloc] init];
    scanWindowModel.msg = @"Scan Window";
    scanWindowModel.placeHolder = @"4 ~ 16384";
    scanWindowModel.detailMsg = @"x 0.625ms";
    scanWindowModel.index = 0;
    [self.section0List addObject:scanWindowModel];
    
    MKTPScanWindowCellModel *intervalModel = [[MKTPScanWindowCellModel alloc] init];
    intervalModel.msg = @"Scan Interval";
    intervalModel.placeHolder = @"4 ~ 16384";
    intervalModel.detailMsg = @"x 0.625ms";
    intervalModel.index = 1;
    [self.section0List addObject:intervalModel];
    
    if ([MKTPDeviceTypeManager shared].supportAdvTrigger) {
        MKTPScanWindowCellModel *triggerModel = [[MKTPScanWindowCellModel alloc] init];
        triggerModel.msg = @"Tracking Trigger";
        triggerModel.placeHolder = @"0~65535";
        triggerModel.detailMsg = @"seconds";
        triggerModel.isNoteMsgCell = YES;
        triggerModel.index = 2;
        [self.section0List addObject:triggerModel];
    }
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Filter Options";
    cellModel.showRightIcon = YES;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    [self.section2List removeAllObjects];
    
    MKTPTrackingIntervalCellModel *cellModel = [[MKTPTrackingIntervalCellModel alloc] init];
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    [self.section3List removeAllObjects];
    
    MKTextButtonCellModel *noteModel = [[MKTextButtonCellModel alloc] init];
    noteModel.msg = @"Tracking Notification";
    noteModel.index = 0;
    noteModel.buttonBackColor = COLOR_WHITE_MACROS;
    noteModel.buttonLabelFont = MKFont(13.f);
    noteModel.buttonTitleColor = UIColorFromRGB(0x2F84D0);
    noteModel.dataList = @[@"Off",@"Light",@"Vibration",@"Light+Vibration"];
    [self.section3List addObject:noteModel];
    
    MKTextButtonCellModel *formatModel = [[MKTextButtonCellModel alloc] init];
    formatModel.msg = @"Tracking Data Format";
    formatModel.index = 1;
    formatModel.buttonBackColor = COLOR_WHITE_MACROS;
    formatModel.buttonLabelFont = MKFont(13.f);
    formatModel.buttonTitleColor = UIColorFromRGB(0x2F84D0);
    formatModel.dataList = @[@"Short(w/o raw data)",@"Long(Incl raw data)"];
    [self.section3List addObject:formatModel];
}

- (void)loadSection4Datas {
    [self.section4List removeAllObjects];
    
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Trackerd Data";
    cellModel.showRightIcon = YES;
    [self.section4List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"TRACKER";
    [self.rightButton setImage:LOADICON(@"MKTrackerPlus", @"MKTPAdvertiserController", @"tp_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self tableHeaderView];
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

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (UISwitch *)trackingSwitch {
    if (!_trackingSwitch) {
        _trackingSwitch = [[UISwitch alloc] init];
        [_trackingSwitch addTarget:self
                            action:@selector(switchViewValueChanged)
                  forControlEvents:UIControlEventValueChanged];
    }
    return _trackingSwitch;
}

- (MKTPTrackerConfigDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKTPTrackerConfigDataModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 70.f)];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 25.f, 120.f, 40.f)];
    msgLabel.backgroundColor = COLOR_WHITE_MACROS;
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = MKFont(15.f);
    msgLabel.text = @"Tracking";
    [headerView addSubview:msgLabel];
    
    self.trackingSwitch.frame = CGRectMake(kViewWidth - 15.f - 45.f, 25.f, 45.f, 50.f);
    [headerView addSubview:self.trackingSwitch];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15.f, 70 - CUTTING_LINE_HEIGHT, kViewWidth - 30.f, CUTTING_LINE_HEIGHT)];
    lineView.backgroundColor = CUTTING_LINE_COLOR;
    [headerView addSubview:lineView];
    
    return headerView;
}

@end
