//
//  UIBarButtonItem+ClearTitle.m
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "UIBarButtonItem+ClearTitle.h"
#import <objc/runtime.h>

@implementation UIBarButtonItem (ClearTitle)

- (BOOL)_buttonTitleUpdatesDisabled {
    return [objc_getAssociatedObject(self, @selector(_buttonTitleUpdatesDisabled)) boolValue];
}

- (void)_setButtonTitleUpdatesDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(_buttonTitleUpdatesDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//- (void)setTitle:(NSString *)title{
//    [super setTitle:[self _buttonTitleUpdatesDisabled] ? @"" : title];
//}

@end
