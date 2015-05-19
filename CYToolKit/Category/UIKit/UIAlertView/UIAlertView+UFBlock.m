//
//  UIAlertView+UFBlock.m
//  ufront2
//
//  Created by cyyun on 14-9-22.
//  Copyright (c) 2014年 cyyun. All rights reserved.
//

#import "UIAlertView+UFBlock.h"
#import "objc/runtime.h"


@implementation UIAlertView (UFBlock)

- (void)setCompletionBlock:(UFAlertViewCompletionBlock)completionBlock
{
    objc_setAssociatedObject(self, @selector(completionBlock), completionBlock, OBJC_ASSOCIATION_COPY);
    if (completionBlock == nil) {
        self.delegate = nil;
    }else{
        self.delegate = self;
    }
}


- (UFAlertViewCompletionBlock)completionBlock
{
    return objc_getAssociatedObject(self, @selector(completionBlock));
}


#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.completionBlock(alertView,buttonIndex);
}

@end
