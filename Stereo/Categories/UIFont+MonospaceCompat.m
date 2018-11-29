//
//  UIFont+UIFont_MonospaceCompat.m
//  Stereo
//
//  Created by Terry Lewis on 3/11/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "UIFont+MonospaceCompat.h"

@import CoreText.SFNTLayoutTypes;

@implementation UIFontDescriptor (MonospaceCompat)

/**
 *  Generates a monospaced font descriptor.
 *
 *  @return monospaced font descriptor.
 */
- (UIFontDescriptor *)monospacedCompatVariant{
    
    NSArray *fontDescriptorFeatures = @[
                                        @{
                                            UIFontFeatureTypeIdentifierKey : @(kNumberSpacingType),
                                            UIFontFeatureSelectorIdentifierKey : @(kMonospacedNumbersSelector)
                                            }
                                        ];
    UIFontDescriptor *descriptor = [self fontDescriptorByAddingAttributes:@{
                                                                            UIFontDescriptorFeatureSettingsAttribute : fontDescriptorFeatures
                                                                            }];
    return descriptor;
}

@end

@implementation UIFont (MonospaceCompat)

/**
 *  Returns a numeral-only-monospaced font instance with the font type and size of the given font.
 *
 *  @return numeral-only-monospaced font variant of input.
 */
- (UIFont *)monospaceFontVariant{
    UIFontDescriptor *oldFontDescriptor = [self fontDescriptor];
    UIFontDescriptor *newFontDescriptor = oldFontDescriptor.monospacedCompatVariant;
    return [UIFont fontWithDescriptor:newFontDescriptor size:self.pointSize];
}

@end
