//
//  MKTPFilterRssiCell.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/29.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTPFilterRssiCellModel : NSObject

@property (nonatomic, assign)NSInteger rssi;

@end

@protocol MKTPFilterRssiCellDelegate <NSObject>

- (void)mk_fliterRssiValueChanged:(NSInteger)rssi;

@end

@interface MKTPFilterRssiCell : MKBaseCell

@property (nonatomic, strong)MKTPFilterRssiCellModel *dataModel;

@property (nonatomic, weak)id <MKTPFilterRssiCellDelegate>delegate;

+ (MKTPFilterRssiCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
