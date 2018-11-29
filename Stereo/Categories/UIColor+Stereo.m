//
//  UIColor+Stereo.m
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "UIColor+Stereo.h"

@implementation UIColor (Stereo)

+ (UIColor *)_weirdPinkColour{
    static UIColor *sharedColour = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedColour = [UIColor colorWithRed:255.0f/255.0f green:45.0f/255.0f blue:85.0f/255.0f alpha:1];
    });
    return sharedColour;
}

+ (UIColor *)_volumeSliderGreyColour{
    static UIColor *sharedColour = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedColour = [UIColor colorWithWhite:0.871 alpha:1.0f];
    });
    return sharedColour;
}

+ (UIColor *)_stereoOrangeColour{
    static UIColor *sharedColour = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedColour = [UIColor colorWithRed:233.0f/255.0f green:101.0f/255.0f blue:38.0f/255.0f alpha:1];
    });
    return sharedColour;
}

@end
