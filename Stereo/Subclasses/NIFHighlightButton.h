//
//  NIFHighlightButton.h
//  Stereo
//
//  Created by Terry Lewis on 29/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIFHighlightButton : UIButton

/**
 *  Highlighted background colour and text colour.
 */
@property (nonatomic, strong) UIColor *h_backgroundColour, *h_textColour;

/**
 *  Highlight colour
 */
@property (nonatomic, strong) UIColor *highlightColour;

@end
