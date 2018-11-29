//
//  NIFExtendedButton.m
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFExtendedButton.h"

@implementation NIFExtendedButton

/**
 *  Function to increase the hit rect of the button.
 *
 *  @param point point that was tapped.
 *  @param event tap event
 *
 *  @return whether the tap was within the bounds of the button.
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) ||       !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    
    return CGRectContainsPoint(hitFrame, point);
}

@end
