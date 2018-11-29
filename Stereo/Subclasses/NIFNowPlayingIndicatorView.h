//
//  NIFNowPlayingIndicatorView.h
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This is actually a pretty cool class.
 *  It's structured to replicate Apple's private API as perfectly as I can manage/be bothered to.
 *  For the header that this class is based off of see: https://github.com/MP0w/iOS-Headers/blob/master/iOS8.1/PrivateFrameworks/MPUFoundation/MPUNowPlayingIndicatorView.h
 *  The header was dumped using class-dump 3.5 by Steve Nygard see: http://stevenygard.com/projects/class-dump/
 */
@interface NIFNowPlayingIndicatorView : UIControl

/**
 *  The colour of the level gutters. If unset, defaults to the tint colour of this view with an alpha component of 0.1f.
 */
@property (retain, nonatomic) UIColor *levelGuttersColor;
/**
 *  Whether or not to show level gutters. Level gutters are a shadow like view behind the levels, they are not animated and are draw at the maximum height of a the levels.
 */
@property (nonatomic) BOOL showsLevelGutters;
/**
 *  The playback state of the level, should be set from the now playing controller.
 */
@property (nonatomic) MPMusicPlaybackState playbackState;
/**
 *  The number of levels.
 */
@property (nonatomic) NSInteger numberOfLevels;
/**
 *  The height of the level when it is at its lowest.
 */
@property (nonatomic) CGFloat minimumLevelHeight;
/**
 *  The height of the level when it is at its highest.
 */
@property (nonatomic) CGFloat maximumLevelHeight;
/**
 *  The width of the levels.
 */
@property (nonatomic) CGFloat levelWidth;
/**
 *  The corner radius of the levels.
 */
@property (nonatomic) CGFloat levelCornerRadius;
/**
 *  The spacing between levels.
 */
@property (nonatomic) CGFloat interLevelSpacing;

@end
