//
//  UIView+Snapshot.m
//  Stereo
//
//  Created by Terry Lewis on 12/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Screenshot)

- (UIImage *)layerContentsAsImageOfSize:(CGSize)size{
//    it's important to use the correct scale multiplier, 1.0f will result in poor quality on anything with retina or better.
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)layerContentsAsImage{
    return [self layerContentsAsImageOfSize:self.bounds.size];
}

@end
