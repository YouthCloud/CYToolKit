//
//  UIAlertView+UFBlock.h
//  ufront2
//
//  Created by cyyun on 14-9-22.
//  Copyright (c) 2014年 cyyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UFAlertViewCompletionBlock)(UIAlertView *alertView,NSUInteger buttonIndex);
@interface UIAlertView (UFBlock)<UIAlertViewDelegate>

@property(nonatomic, copy)UFAlertViewCompletionBlock completionBlock;

@end
