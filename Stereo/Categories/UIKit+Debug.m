//
//  UIApplication+Debug.m
//  Stereo
//
//  Created by Terry Lewis on 18/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "UIKit+Debug.h"

@interface UIApplication (Private)

- (void)addStatusBarStyleOverrides:(NSInteger)override;
- (void)removeStatusBarStyleOverrides:(NSInteger)override;

@end

@implementation UIApplication (Debug)

- (void)setDoubleStatusBarEnabled:(BOOL)enabled{
#if defined(DEBUG) || defined(DEBUG_MODE)
    static int override = 3733;
    if (enabled) {
        [self addStatusBarStyleOverrides:override];
    }else{
        [self removeStatusBarStyleOverrides:override];
    }
#else
#warning This method should not be called in release builds.
#endif
}

@end
