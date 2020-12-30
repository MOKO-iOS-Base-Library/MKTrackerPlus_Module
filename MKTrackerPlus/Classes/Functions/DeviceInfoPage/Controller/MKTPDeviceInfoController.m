//
//  MKTPDeviceInfoController.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPDeviceInfoController.h"

#import "Masonry.h"
#import "MKBaseTableView.h"
#import "MKNormalTextCell.h"
#import "MKMacroDefines.h"
#import "MKHudManager.h"
#import "UIView+MKAdd.h"

#import "MKTPDeviceTypeManager.h"

#import "MKTPDeviceInfoModel.h"

@interface MKTPDeviceInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKTPDeviceInfoModel *dataModel;

@property (nonatomic, assign)BOOL onlyVoltage;

@end

@implementation MKTPDeviceInfoController

- (void)dealloc {
    NSLog(@"MKTPDeviceInfoController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startReadDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadTableDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_tp_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - 读取数据
- (void)startReadDatas {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startLoadSystemInformation:self.onlyVoltage sucBlock:^{
        [[MKHudManager share] hide];
        if (!weakSelf.onlyVoltage) {
            weakSelf.onlyVoltage = YES;
        }
        [weakSelf loadDatasFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadDatasFromDevice {
    if (ValidStr(self.dataModel.batteryVoltage)) {
        MKNormalTextCellModel *soc = self.dataList[0];
        soc.rightMsg = [NSString stringWithFormat:@"%@mV/%@%@",self.dataModel.batteryVoltage,self.dataModel.batteryPower,@"%"];
    }
    if (ValidStr(self.dataModel.macAddress)) {
        MKNormalTextCellModel *mac = self.dataList[1];
        mac.rightMsg = self.dataModel.macAddress;
    }
    if (ValidStr(self.dataModel.deviceModel)) {
        MKNormalTextCellModel *produceModel = self.dataList[2];
        produceModel.rightMsg = self.dataModel.deviceModel;
    }
    if (ValidStr(self.dataModel.software)) {
        MKNormalTextCellModel *softwareModel = self.dataList[3];
        softwareModel.rightMsg = self.dataModel.software;
    }
    if (ValidStr(self.dataModel.firmware)) {
        MKNormalTextCellModel *firmwareModel = self.dataList[4];
        firmwareModel.rightMsg = self.dataModel.firmware;
    }
    if (ValidStr(self.dataModel.hardware)) {
        MKNormalTextCellModel *hardware = self.dataList[5];
        hardware.rightMsg = self.dataModel.hardware;
    }
    if (ValidStr(self.dataModel.manuDate)) {
        MKNormalTextCellModel *manuDateModel = self.dataList[6];
        manuDateModel.rightMsg = self.dataModel.manuDate;
    }
    if (ValidStr(self.dataModel.manu)) {
        MKNormalTextCellModel *manuModel = self.dataList[7];
        manuModel.rightMsg = self.dataModel.manu;
    }
    [self.tableView reloadData];
}

#pragma mark -
- (void)loadTableDatas {
    MKNormalTextCellModel *socModel = [[MKNormalTextCellModel alloc] init];
    socModel.leftMsg = @"Battery";
    socModel.rightMsg = @"0mV";
    [self.dataList addObject:socModel];
    
    MKNormalTextCellModel *macModel = [[MKNormalTextCellModel alloc] init];
    macModel.leftMsg = @"Mac Address";
    macModel.rightMsg = @"CE:12:A4:32:1B:2E";
    [self.dataList addObject:macModel];
    
    MKNormalTextCellModel *produceModel = [[MKNormalTextCellModel alloc] init];
    produceModel.leftMsg = @"Product Model";
    produceModel.rightMsg = @"HHHH";
    [self.dataList addObject:produceModel];
    
    MKNormalTextCellModel *softwareModel = [[MKNormalTextCellModel alloc] init];
    softwareModel.leftMsg = @"Software Version";
    softwareModel.rightMsg = @"V1.0.0";
    [self.dataList addObject:softwareModel];
    
    MKNormalTextCellModel *firmwareModel = [[MKNormalTextCellModel alloc] init];
    firmwareModel.leftMsg = @"Firmware Version";
    firmwareModel.rightMsg = @"V1.0.0";
    [self.dataList addObject:firmwareModel];
    
    MKNormalTextCellModel *hardwareModel = [[MKNormalTextCellModel alloc] init];
    hardwareModel.leftMsg = @"Hardware Version";
    hardwareModel.rightMsg = @"V1.0.0";
    [self.dataList addObject:hardwareModel];
    
    MKNormalTextCellModel *manuDateModel = [[MKNormalTextCellModel alloc] init];
    manuDateModel.leftMsg = @"Manufacture Date";
    manuDateModel.rightMsg = @"1d2h3m15s";
    [self.dataList addObject:manuDateModel];
    
    MKNormalTextCellModel *manuModel = [[MKNormalTextCellModel alloc] init];
    manuModel.leftMsg = @"Manufacture";
    manuModel.rightMsg = @"LTD";
    [self.dataList addObject:manuModel];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"DEVICE";
    [self.rightButton setHidden:YES];
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
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKTPDeviceInfoModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKTPDeviceInfoModel alloc] init];
    }
    return _dataModel;
}

@end
