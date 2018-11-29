//
//  NIFHighlightButton.m
//  Stereo
//
//  Created by Terry Lewis on 29/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFHighlightButton.h"

@implementation NIFHighlightButton

/**
 *  The view that is highlighted when the button is in a selected state.
 *
 *  @return The view that is highlighted when the button is in a selected state.
 */
- (UIImageView *)selectedView{
    for (UIImageView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            if (view.frame.size.width) {
                return view;
            }
        }
    }
    return nil;
}

/**
 *  Sets the title of the button depending on the state.
 *
 *  @param title the title
 *  @param state the state
 */
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    if (state == UIControlStateNormal) {
        self.titleLabel.text = title;
    }
    [super setTitle:title forState:state];
}

@end
