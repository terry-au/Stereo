//
//  NIFSongCell.h
//  Stereo
//
//  Created by Terry Lewis on 28/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIFBaseCell.h"

@interface NIFSongCell : NIFBaseCell

@property (nonatomic, strong) UILabel *trackNumberLabel, *titleLabel, *durationLabel;
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

- (void)setLeftAccessoryViewHidden:(BOOL)trackNumberLabelHidden;

@end
