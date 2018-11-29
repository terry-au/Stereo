//
//  UIFont+UIFont_MonospaceCompat.h
//  Stereo
//
//  Created by Terry Lewis on 3/11/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (MonospaceCompat)

/**
 *  Returns a numeral-only-monospaced font instance with the font type and size of the given font.
 *
 *  @return numeral-only-monospaced font variant of input.
 */
- (UIFont *)monospaceFontVariant;

@end
