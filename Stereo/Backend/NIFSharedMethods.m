//
//  NIFSharedMethods.m
//  Stereo
//
//  Created by Terry Lewis on 20/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFSharedMethods.h"

@implementation NIFSharedMethods

+ (NSAttributedString *)attributedStringForArtist:(NSString *)artist album:(NSString *)album{
    static UIFont *subLabelFont = nil;
    static UIColor *lightGreyColour = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        subLabelFont = [UIFont systemFontOfSize:14.0f];
        lightGreyColour = [UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1];
    });
    NSAttributedString *artistAttributedString = [[NSAttributedString alloc] initWithString:artist attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : subLabelFont}];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:artistAttributedString];
    NSAttributedString *albumAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", album] attributes:@{NSForegroundColorAttributeName : lightGreyColour, NSFontAttributeName : subLabelFont}];
    [attributedString appendAttributedString:albumAttributedString];
    return attributedString;
}

/**
 *  Returns a string representation of a track number. If 0, nil is returned.
 *
 *  @param trackNumber the track number.
 *
 *  @return A string representing the track number.
 */
+ (NSString *)stringFromTrackNumber:(NSUInteger)trackNumber{
    return trackNumber ? [NSString stringWithFormat:@"%lu", (unsigned long)trackNumber] : nil;
}

@end
