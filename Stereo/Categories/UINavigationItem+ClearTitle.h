//
//  NIFClearBackButtonNavigationItem.h
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItem+ClearTitle.h"

@interface UINavigationItem (ClearTitle)

/**
 *  Disables the text on the back bar item.
 */
- (void)disableBackButtonText;

/**
 *  Enables the text on the back bar item.
 */
- (void)enableBackButtonText;

@end
