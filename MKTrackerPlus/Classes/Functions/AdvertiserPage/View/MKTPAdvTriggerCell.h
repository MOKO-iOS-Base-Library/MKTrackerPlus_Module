//
//  MKTPAdvTriggerCell.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTPAdvTriggerCellModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, copy)NSString *advTriggerTime;

@end

@protocol MKTPAdvTriggerCellDelegate <NSObject>

- (void)mk_advTriggerTimeChanged:(NSString *)advTime;

- (void)mk_advTriggerStatusChanged:(BOOL)isOn;

@end

@interface MKTPAdvTriggerCell : MKBaseCell

@property (nonatomic, strong)MKTPAdvTriggerCellModel *dataModel;

@property (nonatomic, weak)id <MKTPAdvTriggerCellDelegate>delegate;

+ (MKTPAdvTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
