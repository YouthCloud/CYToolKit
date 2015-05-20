//
//  DKUtils.h
//  DaoKong
//
//  Created by fanghao on 15-2-3.
//  Copyright (c) 2015年 cyyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertView+UFBlock.h"

@class DKVersionInfo;

@interface DKUtils : NSObject




// 获取当前程序的版本号
+ (NSString *)curAppVersion;

// 判别是否连接网络
+ (BOOL)isNetworkReachable;



/** url编码
 *
 *  input: 待编码的字符串
 *
 */
+ (NSString *)encodeToPercentEscapeString:(NSString *)input;


// 下载最新版本
+ (void)downLoadNewVersion;

// 注册Apns推送
+ (void)registerForRemoteNotifications;

// 取消注册Apns推送
+ (void)unregisterForRemoteNotifications;

+ (NSString*)getLatestLogFileName;

// 重导日志文件
+ (void)redirectNSLogToLogsFolder;


// 显示指定的错误信息
+ (void)showServerErrorMeassage:(NSString *)errorMessage;

+ (NSString *)timeIntervalToString:(NSTimeInterval)timeInterval;

+ (NSData *)compressImage:(UIImage *)orginalImage withMaxSize:(NSUInteger)maxSize;

+ (void)setExtraTableCellLine:(UITableView *)tableView;

+ (BOOL)isBlankString:(NSString *)string;

+ (NSString *)md5:(NSString *)str;

//显示sessionToken失效,帐号互踢
+ (void)showSessionTokenAlertView;

//退出登录
+ (void)exitToLogin;

//友盟统计
+ (void)startUmengService;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

//获取文本高度
+ (CGFloat)heightFromViewWithFont:(UIFont *)font andWidth:(CGFloat)width textContent:(NSString *)textStr;

+ (CGFloat)getHeightFromLabel:(UILabel *)label;


@end
