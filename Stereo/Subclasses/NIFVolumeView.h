//
//  NIFVolumeView.h
//  Stereo
//
//  Created by Terry Lewis on 4/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface NIFVolumeView : MPVolumeView

/**
 *  Probably shouldn't be called unless something breaks.
 *  This /was/ a debug method, left if -absolutely- required.
 */
- (void)updateSliderImages;

@end
