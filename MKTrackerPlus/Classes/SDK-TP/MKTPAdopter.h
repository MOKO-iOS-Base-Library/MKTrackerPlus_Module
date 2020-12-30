//
//  MKTPAdopter.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/24.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTPAdopter : NSObject

+ (NSDictionary *)parseDateString:(NSString *)date;
+ (NSArray *)parseScannerTrackedData:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
