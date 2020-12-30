//
//  MKTPTrackerDataCell.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/28.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTPTrackerDataCell : MKBaseCell

@property (nonatomic, strong)NSDictionary *dataModel;

+ (MKTPTrackerDataCell *)initCellWithTableView:(UITableView *)tableView;

+ (CGFloat)fetchCellHeight:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
