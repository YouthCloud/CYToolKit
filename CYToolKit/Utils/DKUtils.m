//
//  DKUtils.m
//  DaoKong
//
//  Created by fanghao on 15-2-3.
//  Copyright (c) 2015年 cyyun. All rights reserved.
//

#import "DKUtils.h"
#import "DKVersionInfo.h"
#import "CoreTelephony.h"
#import "FYNHttpRequestLoader.h"
#import "Reachability.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <CommonCrypto/CommonDigest.h>

#import "DKAppDelegate.h"
#import "DKLoginViewController.h"
#import "JSONKit.h"
#import "AuthHelper.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <string.h>

extern NSString *sessionToken;
extern NSInteger lid;

static const NSInteger k4MImageDataSize = 4 * 1024 * 1024;  // 4M
static const NSInteger k3MImageDataSize = 3 * 1024 * 1024;
static const NSInteger k2MImageDataSize = 2 * 1024 * 1024;
static const NSInteger k1MImageDataSize = 1 * 1024 * 1024;

@implementation DKUtils


// 获取设备的mac地址
+ (NSString *)macAddress
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *macAddr = [defaults objectForKey:MACADDRESS];
    if (macAddr != nil)
    {
        //NSLog(@"Retrieve mac address from user defaults.");
        return macAddr;
    }
    
    int                 mib[6];
    size_t              len = 0;
    char                *buf = NULL;
    unsigned char       *ptr = NULL;
    struct if_msghdr    *ifm = NULL;
    struct sockaddr_dl  *sdl = NULL;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    mib[5] = if_nametoindex("en0");
    
    if (0 == mib[5])
    {
        NSLog(@"Error: if_nametoindex error.");
        return @"0";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        NSLog(@"Error: sysctl, take 1.");
        return @"0";
    }
    
    buf = malloc(len);
    if (buf == NULL)
    {
        NSLog(@"Error: Could not allocate memory.");
        return @"0";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        NSLog(@"Error: sysctl, take 2.");
        free(buf);
        return @"0";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
    free(buf);
    macAddr = [outstring uppercaseString];
    if ([macAddr length] > 0)
    {
        [defaults setObject:macAddr forKey:MACADDRESS];
        [defaults synchronize];
        //NSLog(@"Save mac address to user defaults.");
        return macAddr;
    }
    else
    {
        return @"0";
    }
}

// 获取设备的IMEI
+ (NSString *)deviceIMEI
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *imei = [defaults objectForKey:DEVICEIMEI];
    if (imei != nil)
    {
        //NSLog(@"Retrieve IMEI from user defaults.");
        return imei;
    }
    
    struct CTServerConnection *connection = NULL;
    struct CTResult result;
    NSDictionary *info = nil;
    
    connection = _CTServerConnectionCreate(kCFAllocatorDefault, callback, NULL);
    _CTServerConnectionCopyMobileEquipmentInfo(&result, connection, &info);
    if (connection != NULL)
    {
        CFRelease(connection);
    }
    
    imei = (NSString*)info[(__bridge NSString*)kCTMobileEquipmentInfoIMEI];
    if ([imei length] == 0)
    {
        imei = @"0";
    }
    
    [defaults setObject:imei forKey:DEVICEIMEI];
    [defaults synchronize];
    //NSLog(@"Save IMEI to user defaults.");
    return imei;
}

// 获取当前程序的版本号
+ (NSString *)curAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return version;
}

// 判别是否连接网络
+ (BOOL)isNetworkReachable
{
    // Create zero address
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        NSLog(@"Could not recover network flags.");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN))
    {
        needsConnection = NO;
    }
    
    return ((isReachable && !needsConnection) ? YES : NO);
}

// 判别当前网络是否为WWAN
+ (BOOL)currentNetworkIsWWAN
{
    BOOL bResult = YES;
    Reachability *r = [Reachability reachabilityForLocalWiFi];
    if ( [r currentReachabilityStatus] == ReachableViaWiFi)
    {
        NSLog(@"正在使用wifi网络");
        bResult = NO;
    }
    else
    {
        NSLog(@"正在使用非wifi网络");
    }
    return bResult;
}

// 判别是否需要自动登陆
+ (BOOL)shouldAutoLoginToServer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:AUTOLOGIN];
}

+ (BOOL)shouldReceivePictureOnCellNetwork
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:USERNAME];
    NSString *key = [NSString stringWithFormat:@"%@_%@", SHOULDRECEIVEPICONCELL, userName];
    return [defaults boolForKey:key];
}



 //检测版本更新
+ (DKVersionInfo*)checkNewVersion
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@/ClientVersionCheck", APPHUBURL];
    NSURL *checkUrl = [NSURL URLWithString:stringUrl];
    
    NSString *version = [self curAppVersion];
    NSString *paramsStr = @"device=idk&";
    paramsStr = [paramsStr stringByAppendingFormat:@"version=%@", version];
    
    FYNHttpRequestLoader *httpRequestLoader = [[FYNHttpRequestLoader alloc] init];
    NSData *receiveData = [httpRequestLoader startSynRequestWithURL:checkUrl withParams:paramsStr];
    if (receiveData != nil)
    {
        NSString *resultStr = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
        if ([resultStr length] == 0)
        {
            NSLog(@"服务器返回的数据为空.");
        }
        else
        {
            NSString *latestVersion = nil;
            BOOL isForceUpdate = NO;
            BOOL isHasNewVersion = NO;
            NSString *updateDescription = nil;
            NSDictionary *resultDic = [resultStr objectFromJSONString];
            if ([resultDic count] <= 0)
            {
                NSLog(@"服务器返回的数据格式错误: %@.", resultDic);
            }
            else
            {
                NSLog(@"%@",resultDic);
                VEJsonParser *jsonParser = [[VEJsonParser alloc] initWithJsonDictionary:resultDic];
                NSInteger resValue = [jsonParser retrieveRusultValue];
                latestVersion = [jsonParser retrieveLatestVersionValue];
                isForceUpdate = [jsonParser retrieveIsForceUpdateValue];
                updateDescription = [jsonParser retrieveUpdateDescriptionValue];
                if (resValue == HasNewVersion)
                {
                    NSLog(@"--- have new version. ---");
                    isHasNewVersion = YES;
                }
                else if (resValue == NoNewVersion)
                {
                    NSLog(@"--- no new version. ---");
                }
                else
                {
                    NSLog(@"server error code: %ld, discription: %@", (long)[jsonParser retrieveRusultValue], [jsonParser retrieveServerErrorMessageValue]);
                }
                
                DKVersionInfo *versionInfo = [[DKVersionInfo alloc] initWithLatesteVersionNumber:latestVersion isForceUpdate:isForceUpdate isHasNewVersion:isHasNewVersion updateDescription:updateDescription];
                return versionInfo;
            }
        }
    }
    
    return NO;
}
// url编码
+ (NSString *)encodeToPercentEscapeString:(NSString *)input
{
    NSString *output = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)input, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return output;
}

// 下载最新版本
+ (void)downLoadNewVersion
{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *updateUrl = [NSURL URLWithString:UPDATE_URL];
    NSLog(@"updateUrl: %@", updateUrl);
    if ([app canOpenURL:updateUrl] == YES)
    {
        [app openURL:updateUrl];
    }
    else
    {
        NSLog(@"no application is available that will accept the update URL.");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"更新提示"
                                                       message:@"您的设备不支持打开更新链接"
                                                      delegate:nil
                                             cancelButtonTitle:@"好的"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

// 注册Apns推送
+ (void)registerForRemoteNotifications
{
    //消息推送支持的类型
    UIRemoteNotificationType types = (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound);
    //注册消息推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    
}

// 取消注册Apns推送
+ (void)unregisterForRemoteNotifications
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

// 显示指定的错误信息
+ (void)showServerErrorMeassage:(NSString *)errorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil];
    [alert show];
}


+ (NSString*)getLatestLogFileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError  *error = nil;
    NSString *logsFolderPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:LogsFolder];
    NSArray *dirArray = [fileManager contentsOfDirectoryAtPath:logsFolderPath error:&error];
    if(dirArray.count > 0){
        NSArray *sortedArray = [dirArray sortedArrayUsingSelector:@selector(compare:)];  // 升序排列
        return sortedArray[sortedArray.count -1];
    }else{
        return nil;
    }
}

// 重导日志文件
+ (void)redirectNSLogToLogsFolder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError  *error = nil;
    NSString *logsFolderPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:LogsFolder];
    BOOL result = [fileManager createDirectoryAtPath:logsFolderPath
                         withIntermediateDirectories:YES
                                          attributes:nil
                                               error:&error];
    if (result == NO) return;
    
    NSArray *dirArray = [fileManager contentsOfDirectoryAtPath:logsFolderPath error:&error];
    if ([dirArray count] >= LogFilePersistentDays)
    {
        NSInteger difference = [dirArray count] - LogFilePersistentDays;
        NSArray *sortedArray = [dirArray sortedArrayUsingSelector:@selector(compare:)];  // 升序排列
        for (NSInteger i = 0; i <= difference; ++i)
        {
            [fileManager removeItemAtPath:[logsFolderPath stringByAppendingPathComponent:[sortedArray objectAtIndex:i]]
                                    error:&error];
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy_MM_dd"];
    NSString *stringDate = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logsFolderPath stringByAppendingPathComponent:stringDate];
    logFilePath = [logFilePath stringByAppendingPathExtension:@"txt"];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    NSLog(@"===================== Start =====================");
}


// 将时间类型数据转换为字符串
+ (NSString *)timeIntervalToString:(NSTimeInterval)timeInterval
{
    NSNumber *numTimeInterval = [NSNumber numberWithLongLong:timeInterval];
    return [numTimeInterval stringValue];
}

+ (NSData *)compressImage:(UIImage *)orginalImage withMaxSize:(NSUInteger)maxSize
{
    NSData *orignalImageData = UIImageJPEGRepresentation(orginalImage, 1.0);
    NSUInteger orignalImageSize = [orignalImageData length];
    NSLog(@"orignalImageSize: %d", orignalImageSize);
    if (orignalImageSize > maxSize)
    {
        float i = 0.9;
        if (orignalImageSize >= k4MImageDataSize)
        {
            i = 0.15;
        }
        else if (orignalImageSize >= k3MImageDataSize)
        {
            i = 0.3;
        }
        else if (orignalImageSize >= k2MImageDataSize)
        {
            i = 0.45;
        }
        else if (orignalImageSize >= k1MImageDataSize)
        {
            i = 0.75;
        }
        NSLog(@"beginning compress index: %f", i);
        float step = 0.15;
        for (; i > 0; (i -= step))
        {
            NSData *imageCompressedData = UIImageJPEGRepresentation(orginalImage, i);
            NSUInteger imageCompressedSize = [imageCompressedData length];
            if ((imageCompressedSize <= maxSize) || (i - step) <= 0.0001)
            {
                NSLog(@"imageCompressedSize: %d, %f", imageCompressedSize, i);
                return imageCompressedData;
            }
        }
    }
    return orignalImageData;
}



+(void)setExtraTableCellLine:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string.length == 0) {
        return YES;
    }
    //去除两端的空格
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmedString.length == 0) {
        return YES;
    }
    return NO;
}

+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (void)setLoginViewControllerAsRootController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DKLoginViewController *loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    DKAppDelegate *appDelegate = (DKAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = loginViewController;
}

+ (void)setTabbarViewControllerAsRootController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UITabBarController *tabBarController = [storyBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
    DKAppDelegate *appDelegate = (DKAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = tabBarController;
}


+ (void)showSessionTokenAlertView
{
    NSLog(@"SessionToken失效---》账户在其他地方登录");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的帐号在其他地方登录。如果这不是你的操作，你的密码可能已经泄露。请重新登录！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新登录", nil];
    alertView.completionBlock = ^(UIAlertView *alertView,NSUInteger buttonIndex){
        if (buttonIndex == 0) {
            [self exitToLogin];
        }
    };
    [alertView show];
}

+ (void)exitToLogin
{
    //取消注册推送服务
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    //取消自动登录
    [[DKUserInfoManager shareManager] updateAutoLoginWithUserName:USER_INFO.userName autoLogin:NO];
    DKAppDelegate *appDelegate = (DKAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
        tabBarController.viewControllers = nil;
        [[AuthHelper getInstance] logoutVpn];
        [self setLoginViewControllerAsRootController];
    }
}

//注册Umeng统计
+ (void)startUmengService
{
    NSArray *versionInfos = [APP_VERSION componentsSeparatedByString:@"_"];
    
    if (versionInfos.count == 1) {
        [MobClick setAppVersion:APP_VERSION];
        [MobClick setCrashReportEnabled:YES];
        //  [MobClick setLogEnabled:YES];
        
        [MobClick startWithAppkey:UMAnalyticsAppKey];
    }
}


+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (CGFloat)heightFromViewWithFont:(UIFont *)font andWidth:(CGFloat)width textContent:(NSString *)textStr
{
    CGSize textBlockSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize retSize;
    if (IOS_VERSION >= 7.0) {
        retSize = [textStr boundingRectWithSize:textBlockSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }else{
        retSize = [textStr sizeWithFont:font constrainedToSize:textBlockSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    return retSize.height;
}

+ (CGFloat)getHeightFromLabel:(UILabel *)label
{
    CGSize textBlockSize = CGSizeMake(CGRectGetWidth(label.bounds), CGFLOAT_MAX);
    CGSize retSize;
    if (IOS_VERSION >= 7.0) {
        retSize = [label.text boundingRectWithSize:textBlockSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    }else{
        retSize = [label.text sizeWithFont:label.font constrainedToSize:textBlockSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    return retSize.height;
}

+ (NSUInteger)checkChinaMobileType
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        return dkMobileType_unknown;
    }
    
    NSString *mobileNetCode = [carrier mobileNetworkCode];
    if (mobileNetCode == nil) {
        return dkMobileType_unknown;
    }
    if ([@[@"00",@"02",@"07"] containsObject:mobileNetCode]) {
        return dkMobileType_chinaMobile;
    }
    if ([@[@"01",@"06"] containsObject:mobileNetCode]) {
        return dkMobileType_chinaUnicom;
    }
    if ([@[@"03",@"05"] containsObject:mobileNetCode]) {
        return dkMobileType_chinaTeleCom;
    }
    
    return dkMobileType_unknown;
}

+ (NSString *)getIpStringByHostName:(NSString *)hostName
{
    NSString *ipString = nil;
    struct addrinfo *answer, hint, *curr;
    char ipstr[16];
    bzero(&hint, sizeof(hint));
    hint.ai_family = AF_INET;
    hint.ai_socktype = SOCK_STREAM;
    
    int ret = getaddrinfo([hostName cStringUsingEncoding:NSUTF8StringEncoding], NULL, &hint, &answer);
    if (ret != 0) {
        return nil;
    }
    
    for (curr = answer; curr != NULL; curr = curr->ai_next) {
        inet_ntop(AF_INET,
                  &(((struct sockaddr_in *)(curr->ai_addr))->sin_addr),
                  ipstr, 16);
        
        ipString = [NSString stringWithCString:ipstr encoding:NSUTF8StringEncoding];
        
    }
    
    freeaddrinfo(answer);
    return ipString;
}

@end
