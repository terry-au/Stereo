//
//  NIFImageSongCell.h
//  Stereo
//
//  Created by Terry Lewis on 7/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIFBaseCell.h"
#import "NIFSlantedTextPlaceholderArtworkView.h"

@interface NIFImageSongCell : NIFBaseCell

/**
 *  The artwork view.
 */
@property (nonatomic, strong) UIImageView *artworkImageView;
/**
 *  Whether the cell is now playing.
 */
@property (nonatomic, getter=isPlaying) BOOL playing;
/**
 *  The now playing indicator for the cell.
 *
 *  @return the now playing indicator.
 */
- (NIFNowPlayingIndicatorView *)nowPlayingIndicator;

@end
