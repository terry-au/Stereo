//
//  NIFDetailSlider.h
//  Stereo
//
//  Created by Terry Lewis on 5/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIFNowPlayingTitlesView.h"

@interface NIFDetailSlider : UIView

/**
 *  Weak reference to the now playing titles view, used to update titles in order to reflect srubbing speed and information relating to it.
 */
@property (nonatomic, weak) NIFNowPlayingTitlesView *nowPlayingTitlesView;

/**
 *  Updates the slider's min and max to applicable values for the currently playing media item.
 *
 *  @param mediaItem the media item used to derive values from.
 */
- (void)updateScaleWithMediaItem:(MPMediaItem *)mediaItem;

@end
