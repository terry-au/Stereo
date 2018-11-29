//
//  UIView+Snapshot.h
//  Stereo
//
//  Created by Terry Lewis on 12/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

/**
 *  Returns an screenshot of a layer of a given size.
 *
 *  @param size the aformentioned image size.
 *
 *  @return the image
 */
- (UIImage *)layerContentsAsImageOfSize:(CGSize)size;

/**
 *  returns a screenshot of the layer given the layers current bounds
 *
 *  @return the aformentioned image
 */
- (UIImage *)layerContentsAsImage;

@end
