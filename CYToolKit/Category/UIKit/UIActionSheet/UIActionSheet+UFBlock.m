//
//  UIActionSheet+UFBlock.m
//  ufront2
//
//  Created by cyyun on 14-10-16.
//  Copyright (c) 2014年 cyyun. All rights reserved.
//

#import "UIActionSheet+UFBlock.h"
#import "objc/runtime.h"

@implementation UIActionSheet (UFBlock)

static void *DKMyActionSheetKey = @"DKMyActionSheetKey";

- (id)initWithTitle:(NSString *)title andButtonTitleArray:(NSArray *)array andCompletionBlock:(DKActionSheetCompletionBlock)block
{
    self = [self initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    if (self) {
        for (NSString *buttonTitle in array) {
            [self addButtonWithTitle:buttonTitle];
        }
        [self addButtonWithTitle:@"取消"];
        [self setCancelButtonIndex:(array.count)];
    }
    objc_setAssociatedObject(self, DKMyActionSheetKey, block, OBJC_ASSOCIATION_COPY);
    self.delegate = self;
    return self;
}

- (id)initWithButtonTitleArray:(NSArray *)array andCompletionBlock:(DKActionSheetCompletionBlock)block
{
    self = [self initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    if (self) {
        for (NSString *buttonTitle in array) {
            [self addButtonWithTitle:buttonTitle];
        }
        [self addButtonWithTitle:@"取消"];
        [self setCancelButtonIndex:(array.count)];
    }
    objc_setAssociatedObject(self, DKMyActionSheetKey, block, OBJC_ASSOCIATION_COPY);
    self.delegate = self;
    
    return self;
}



#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DKActionSheetCompletionBlock completionBlock = objc_getAssociatedObject(actionSheet, DKMyActionSheetKey);
    completionBlock(actionSheet,buttonIndex);
}

@end
