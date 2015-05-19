//
//  UIViewController+HUD.m
//  DaoKong
//
//  Created by cyyun on 15-2-3.
//  Copyright (c) 2015年 cyyun. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

#define TABBAR_HEIGHT 44
#define SPACING_TABBAR_HUD 10
#define HUD_HEIGHT  30

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = hint;
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint {

    CGFloat ScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = ScreenHeight/2 - TABBAR_HEIGHT- SPACING_TABBAR_HUD-HUD_HEIGHT;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = 200.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hideHud{
    [[self HUD] hide:YES];
}

@end
