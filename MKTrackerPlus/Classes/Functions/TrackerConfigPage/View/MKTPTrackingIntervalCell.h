//
//  MKTPTrackingIntervalCell.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTPTrackingIntervalCellModel : NSObject

@property (nonatomic, copy)NSString *trackingInterval;

@end

@protocol MKTPTrackingIntervalCellDelegate <NSObject>

- (void)mk_trackingIntervalValueChanged:(NSString *)interval;

@end

@interface MKTPTrackingIntervalCell : MKBaseCell

@property (nonatomic, strong)MKTPTrackingIntervalCellModel *dataModel;

@property (nonatomic, weak)id <MKTPTrackingIntervalCellDelegate>delegate;

+ (MKTPTrackingIntervalCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
