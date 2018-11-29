//
//  NIFExtendedButton.h
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIFExtendedButton : UIButton

/**
 *  Set the insets in order to extend the button hit rect, negative numbers must be provided.
 */
@property (nonatomic) UIEdgeInsets hitTestEdgeInsets;

@end
