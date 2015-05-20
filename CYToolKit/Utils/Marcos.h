//
//  Marcos.h
//  DaoKong
//
//  Created by fanghao on 15-2-3.
//  Copyright (c) 2015年 cyyun. All rights reserved.
//

#ifndef DaoKong_Marcos_h
#define DaoKong_Marcos_h



#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#define USER_INFO           [DKUserInfoManager shareManager].userInfo
#define IOS_VERSION         [[[UIDevice currentDevice] systemVersion] floatValue]
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]



////////////////////////////////////////////////////////////////////////////////


#define tabbarItemImage_latestAlert     @"latestAlert.png"
#define tabbarItemImage_recommendRead   @"recommendRead.png"
#define tabbarItemImage_favorite        @"favourite.png"
#define tabbarItemImage_searchAlert     @"searchAlert.png"
#define tabbarItemImage_moreSetting     @"moreSetting.png"

#define favorite_alerts_log             @"ico-favorite-alerts.png"
#define favorite_recommend_log          @"ico-favorite-recommend.png"

#define levelImage_green        @"list-green.png"
#define levelImage_blue         @"list-blue.png"
#define levelImage_yellow       @"list-yellow.png"
#define levelImage_red          @"list-red.png"

#define levelImage_blue_detail          @"ico_lvyb.png"
#define levelImage_yellow_detail        @"ico_lvzy.png"
#define levelImage_red_detail           @"ico_lvjj.png"

#define backgroundImage_white   @"bar-listbg-new.png"
#define backgroundImage_gray    @"bar-listbg-old.png"

#define recommendRead_newFlagPic    @"ico-new.png"
#define default_thunmbPic           @"picture-min.png"

#define background_logout_normal     @"btm-logout-normal-.png"
#define background_logout_pressed    @"btm-logout-pressed-.png"

////////////////////////////////////////////////////////////////////////////////


#define BarTintColor [UIColor colorWithRed:0.2344f green:0.5469f blue:0.6094f alpha:1.00f]
#define BackgroundColor [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f]

#define unread_titleColor [UIColor colorWithRed:68.0f/255.0f green:68.0f/255.0f blue:68.0f/255.0f alpha:1.00f]
#define mainTitle_titleColor unread_titleColor
#define detailTitle_titleColor [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.00f]

#define read_titleColor [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.00f]
#define accountAndVersion_titleColor read_titleColor

#define newAlertRule_right_titleColor [UIColor colorWithRed:60.0f/255.0f green:140.0f/255.0f blue:156.0f/255.0f alpha:1.00f]
#define promptView_background_gray [UIColor colorWithRed:0.8203f green:0.8281f blue:0.8594f alpha:1.00f]

////////////////////////////////////////////////////////////////////////////////


//#define COMMONURL                 @"http://chonseng.eicp.net:88/dk-mobile/mobile"
//#define APPHUBURL                @"http://www.cyyun.com/mobiledownload/mobile"
//#define UPDATE_URL              @"http://www.cyyun.com/down/beta/dk"


//#define COMMONURL                @"http://hy.chonseng.com:8085/dk-mobile/mobile"
//#define APPHUBURL                @"http://www.cyyun.com/mobiledownload/mobile"
//#define UPDATE_URL              @"http://www.cyyun.com/down/rls/dk"


#define COMMONURL                @"http://10.34.131.207/dk-mobile/mobile"
#define APPHUBURL                @"http://www.cyyun.com/mobiledownload/mobile"
#define UPDATE_URL              @"http://www.cyyun.com/down/rls/dk"

///////////////////////////////VPN--INFO///////////////////////////////////////////

#define VPN_HOST_NAME                        @"vpn2.nbyz.gov.cn"
#define VPN_IP_ChinaTelecom                  @"60.190.59.214"
#define VPN_IP_ChinaUniom                    @"221.12.47.43"
#define VPN_IP_ChinaMobile                   @"112.14.180.144"
#define VPN_PORT                443
#define VPN_USERNAME            @"yuqingdaokong"
#define VPN_PASSWORD            @"yuqingdaokong@87523306"
#define AUTH_TIMEOUT            @"25"


//////////////////////////////////////////////////////////////////////////////////



#define DAOKONGDBNAME @"daokong.sqlite3"

#define DKAppEnterForeNotification   @"DKAppEnterForeNotification"
#define DKAppDidReceiveRemoteNotification   @"DKAppDidReceiveRemoteNotification"
#define DKAppSignInSuccessNotification      @"DKAppSignInSuccessNotification"

#define USERNAME                @"userName"
#define PASSWORD                @"VEPassWord"
#define APNSTOKEN               @"VEApnsToken"

#define VETableCellTitleTag                 10
#define VETableCellSiteTag                  11
#define VETableCellCountsTag                11
#define VETableCellTimeTag                  12
#define VETableCellLevelImageTag            13
#define VETableCellNewImageTag              13
#define VETableCellthumbImageTag            13
#define VETableCellBackgroundImageTag       14
#define VETableCellLogImageTag              15

#define MACADDRESS              @"VEMacAddress"
#define DEVICEIMEI              @"VEDeviceIMEI"

#define SHOULDRECEIVEPICONCELL  @"VEShouldReceivePictureOnCell"
#define AUTOLOGIN               @"VEAutologin"

#define RESULT                  @"result"
#define SESSIONTOKEN            @"sessionToken"
#define MESSAGE                 @"message"
#define LATESTWARNTIME          @"VELatestWarnTime"

#define SIZE                    @"size"
#define CONTENT                 @"content"
#define WARNFAVORITES           @"warnFavorites"
#define FAVORITECOUNTS          @"count"

#define VEabContent               @"abContent"    // String
#define VEaid                     @"aid"          // Integer64
#define VErealAid                 @"realAid"          // Integer64
#define VEauthor                  @"author"       // String
#define VEabstract                @"abstract"
#define VEcontent                 @"content"      // String
#define VEisread                  @"isread"       // String
#define VElevel                   @"level"        // Integer32
#define VEsite                    @"site"         // String
#define VEtitle                   @"title"        // String
#define VEtmPost                  @"tmPost"       // String
#define VEtmWarn                  @"tmWarn"       // Double
#define VEurl                     @"url"          // String
#define VEWarnType                @"warnType"     // Integer16          // warnType，1：普通预警，2：定制预警，3：推荐阅读
#define VEfirstReadTime           @"fristReadTime"          // Double

#define VEIsReply                 @"isReply"
#define VEreplyContent            @"replyContent"

#define VEImageURLs               @"imageUrls"
#define VEImageURL                @"imageUrl"
#define VEThumbImageUrl           @"thumbImageUrl"
#define VEnewestSectionArticleID  @"newestSectionArticleId"
#define VEtmFavorites             @"tmFavorites"
#define VERecommendColumnID       @"columnID"

#define warnType_ordinary           1
#define wanType_custom              2
#define warnType_recommed           3

#define ChangeAlertRuleAction       411

#define MAXPAGES                    10
#define MAXSIZES                    20
#define tabbarItemImage_offset      6
#define No_Picture                  6
#define Has_Picture                 5
#define LogFilePersistentDays       7
#define MinFontSize                 10
#define MaxFontSize                 26
#define HasNewVersion               10
#define NoNewVersion                11
#define CheckVersionInterval        86400              // 1天
#define IntMaxValue                 2147483547

#define TableCellRowHeight          50
#define TableCellGapHeight          8
#define TableCellHeaderHeight       8
#define TableCellFooterHeight       8

#define VEColumnIcon                @"icon"
#define VEColumnID                  @"id"
#define VEContentID                 @"aid"
#define VEColumnTitle               @"title"
#define VEColumnComment             @"comment"


//   #define ShareSDKAPPKEY              @"9c3bd2d068d"
#define UMAnalyticsAppKey           @"54d315edfd98c563400005c7"

#define QuitCurrentAcount           @"退出当前帐号"
#define ContactApproach             @"contact@cyyun.com"
// #define SupportApproach             @"support@cyyun.com"
#define SupportApproach             @"fanyn@cyyun.com"
#define MailSubject                 @"舆情快递-IPhone版 日志文件"

#define SearchHistory               @"VESearchHistory"
#define LogsFolder                  @"Logs"

#define AlertRuleWord               @"word"
#define AlertRuleID                 @"wrid"
#define AlertRuleCreateTime         @"createTime"
#define AlertRuleReadCount          @"readCount"
#define AlertRuleReplyCount         @"replyCount"
#define AlertRuleStyle              @"style"
#define AlertRuleAndKeywords        @"andKeywords"
#define AlertRuleNonKeywords        @"nonKeywords"
#define AlertRuleName               @"desc"

/////////////////////////////////////////////////////////////////////////////
// 自定义页面路径名称


#define LoginView                           @"LoginView"
#define LatestAlertFilterResultsView        @"LatestAlertFilterResultsView"
#define LatestAlertFilterView               @"LatestAlertFilterView"
#define LatestAlertView             @"LatestAlertView"
#define DetailView                  @"DetailView"
#define RecommendReadView           @"RecommendReadView"
#define RecommendColumnView         @"RecommendColumnView"
#define FavoriteView                @"FavoriteView"
#define SearchView                  @"SearchView"
#define SearchResultView            @"SearchResultView"
#define MoreSettingView             @"MoreSettingView"
#define AboutUsView                 @"AboutUsView"
#define HelpMeView                  @"HelpMeView"
#define HelpMeDetailView            @"HelpMeDetailView"
#define ChangePWView                @"ChangePassWordView"
#define UploadLogView               @"UploadLogView"
#define OriginalWebView             @"OriginalWebView"
#define AlertRulesView              @"AlertRulesView"
#define NewOrChangeAlertRuleView    @"NewOrChangeAlertRuleView"

#define AlertDistributeView         @"AlertDistributeView"
#define AlertContactsView           @"AlertContactsView"
#define AlertNotificationView       @"AlertNotificationView"

/////////////////////////////////////////////////////////////////////////////
// 自定义事件


#define PullDownToRefreshEvent      @"PullDownToRefresh"
#define AddFavoriteEvent            @"AddFavorite"
#define RemoveFavoriteEvent         @"RemoveFavorite"
#define OriginalLinkEvent           @"OriginalLink"
#define ShareCopyEvent              @"ShareCopy"
#define ShareMailEvent              @"ShareMail"
#define ShareSMSEvent               @"ShareSMS"
#define PreviousPageEvent           @"PreviousPage"
#define NextPageEvent               @"NextPage"
#define CheckNewVersionEvent        @"CheckNewVersion"
#define PinchZoomInOutEvent         @"PinchZoomInOut"
#define SwitchLatestAlertCategoryEvent          @"SwitchLatestAlertCategory"
#define RefreshAllLatestAlertsEvent             @"RefreshAllLatestAlerts"
#define MarkAllLatestAlertsReadEvent            @"MarkAllLatestAlertsRead"
#define EnterAlertRuleFromLatestAlertEvent      @"EnterAlertRuleFromLatestAlert"
#define LatestAlertFilterEvent                  @"LatestAlertFilter"
#define CallUsEvent                 @"CallUs"
#define CallUsViaEmailEvent         @"CallUsViaEmail"
#define ChangePassWordEvent         @"ChangePassWord"
#define UpLoadLogEvent              @"UpLoadLog"
#define NewAlertRuleEvent           @"NewAlertRule"
#define DeleteAlertRuleEvent        @"DeleteAlertRule"

#define AlertDistributeEvent        @"AlertDistribute"
#define ClickDistributeAlertEvent   @"ClickDistributeAlert"

#define BRANCH  @"brZF"

#endif
