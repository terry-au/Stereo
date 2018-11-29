//
//  UIBarButtonItem+ClearTitle.h
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ClearTitle)

@property (nonatomic, setter=_setButtonTitleUpdatesDisabled:, getter=_buttonTitleUpdatesDisabled) BOOL buttonTitleUpdatesEnabled;

@end
