//
//  UIApplication+Debug.h
//  Stereo
//
//  Created by Terry Lewis on 18/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Private)

- (NSString *)recursiveDescription;

@end

@interface UIApplication (Debug)

- (void)setDoubleStatusBarEnabled:(BOOL)enabled;

@end
