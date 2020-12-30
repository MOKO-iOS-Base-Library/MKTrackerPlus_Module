//
//  UIApplication+MKAdd.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/29.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "UIApplication+MKAdd.h"
#import <sys/utsname.h>

@implementation UIApplication (MKAdd)

+ (void)skipToHome{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                       options:@{}
                             completionHandler:nil];
}

+ (BOOL)applicationInstall:(NSString *)appKey{
    if (!appKey || ![appKey isKindOfClass:[NSString class]] || appKey.length == 0) {
        return NO;
    }
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appKey]];
}

+ (NSString *)currentSystemLanguage{
    // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        //英文
        return @"en";
    }
    if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            // 简体中文
            return @"zh-Hans";
        } else {
            // zh-Hant\zh-HK\zh-TW,繁體中文
            return @"zh-Hant";
        }
    }
    if ([language hasPrefix:@"ja"]) {
        //日本
        return @"ja";
    }
    if ([language hasPrefix:@"cs"]) {
        //捷克
        return @"cs";
    }
    if ([language hasPrefix:@"de"]) {
        //德语
        return @"de";
    }
    if ([language hasPrefix:@"fr"]) {
        //法语
        return @"fr";
    }
    if ([language hasPrefix:@"it"]) {
        //意大利
        return @"it";
    }
    if ([language hasPrefix:@"ko"]) {
        //韩语
        return @"ko";
    }
    if ([language hasPrefix:@"es"]) {
        //西班牙
        return @"es";
    }
    if ([language hasPrefix:@"pt"]) {
        //葡萄牙
        return @"pt";
    }
    if ([language hasPrefix:@"ru"]) {
        //俄语
        return @"ru";
    }
    
    if ([language hasPrefix:@"th"]) {
        //泰语
        return @"th";
    }
    
    return @"en";
}

+ (NSString *)currentIphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString * deviceString = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if([deviceString isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if([deviceString isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if([deviceString isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if([deviceString isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if([deviceString isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if([deviceString isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if([deviceString isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if([deviceString isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if([deviceString isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if([deviceString isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max (China)";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if([deviceString isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";
    if ([deviceString isEqualToString:@"iPhone13,1"])    return @"iPhone 12 mini";
    if ([deviceString isEqualToString:@"iPhone13,2"])    return @"iPhone 12";
    if ([deviceString isEqualToString:@"iPhone13,3"])    return @"iPhone 12 Pro";
    if ([deviceString isEqualToString:@"iPhone13,4"])    return @"iPhone 12 Pro Max";
    
    if([deviceString isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if([deviceString isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if([deviceString isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if([deviceString isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if([deviceString isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if([deviceString isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if([deviceString isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if([deviceString isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if([deviceString isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if([deviceString isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if([deviceString isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if([deviceString isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if([deviceString isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if([deviceString isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if([deviceString isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if([deviceString isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if([deviceString isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if([deviceString isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if([deviceString isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if([deviceString isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if([deviceString isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if([deviceString isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if([deviceString isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if([deviceString isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if([deviceString isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if([deviceString isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if([deviceString isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if([deviceString isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    if([deviceString isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    if([deviceString isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    if([deviceString isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if([deviceString isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if([deviceString isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    if([deviceString isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    if([deviceString isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    if([deviceString isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    if([deviceString isEqualToString:@"i386"]) return @"iPhone Simulator";
    if([deviceString isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return deviceString;
    
}

@end
