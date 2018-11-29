//
//  NIFVignetteBackgroundView.m
//  Stereo
//
//  Created by Terry Lewis on 7/11/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFVignetteBackgroundView.h"
#import <dlfcn.h>

@implementation NIFVignetteBackgroundView

- (UIImage *)vignetteImage{
    return [UIImage imageNamed:@"VignetteBackground.png"];
}

//- (UIImage *)vignetteImageOfSize:(CGSize)size{
//    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
//    UIGraphicsBeginImageContext(rect.size);
////    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
//    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
//    
//    UIImage *whiteImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    CIImage *ciImage = [CIImage imageWithCGImage:whiteImage.CGImage];
//    CIFilter *filter = [CIFilter filterWithName:@"CIVignette" keysAndValues:kCIInputImageKey, ciImage,
//                        @"inputIntensity", @0.5, nil];
//    
//    UIImage *image = [UIImage imageWithCIImage:[filter outputImage]];
//    return image;
//}

- (BOOL)shouldSetImage{
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        if ([self shouldSetImage]) {
            self.image = [self vignetteImage];
        }
    }
    return self;
}

@end
