//
//  UIActionSheet+UFBlock.h
//  ufront2
//
//  Created by cyyun on 14-10-16.
//  Copyright (c) 2014年 cyyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DKActionSheetCompletionBlock)(UIActionSheet *actionSheet, NSUInteger buttonIndex);
@interface UIActionSheet (UFBlock)<UIActionSheetDelegate>

- (id)initWithTitle:(NSString *)title andButtonTitleArray:(NSArray *)array andCompletionBlock:(DKActionSheetCompletionBlock)block;
- (id)initWithButtonTitleArray:(NSArray *)array andCompletionBlock:(DKActionSheetCompletionBlock)block;

@end
