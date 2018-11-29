//
//  NIFImageSongCell.m
//  Stereo
//
//  Created by Terry Lewis on 7/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFImageSongCell.h"
#import "NIFNowPlayingIndicatorView.h"

@implementation NIFImageSongCell{
    UIView *_labelContainerView;
    UILabel *_albumArtistLabel, *_titleLabel;
    UIImageView *_artworkImageView;
    NIFNowPlayingIndicatorView *_indicatorView;
}

/**
 *  Sets up the views.
 */
- (void)setupViews{
    _labelContainerView = [UIView newAutoLayoutView];
    _albumArtistLabel = [UILabel newAutoLayoutView];
    _albumArtistLabel.textAlignment = NSTextAlignmentLeft;
    _albumArtistLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel = [UILabel newAutoLayoutView];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _artworkImageView = [UIImageView newAutoLayoutView];
    _artworkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _artworkImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_labelContainerView addSubview:_titleLabel];
    [_labelContainerView addSubview:_albumArtistLabel];
    [self.contentView addSubview:_labelContainerView];
    [self.contentView addSubview:_artworkImageView];
}


/**
 *  Sets up the constraints.
 */
- (void)setupConstraints{
    NSArray *containerConstraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        
//        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:marginInset()];
//        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:4];
        [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        
//        [_albumArtistLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:marginInset()];
//        [_albumArtistLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:4];
        [_albumArtistLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [_albumArtistLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel withOffset:4];
        
    }];
    [_labelContainerView addConstraints:containerConstraints];
    
    NSArray *constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        [_artworkImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(4, 4, 4, 4) excludingEdge:ALEdgeRight];
        [_artworkImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_artworkImageView];
        
//        [_labelContainerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(marginInset(), 4, marginInset(), 4) excludingEdge:ALEdgeLeft];
//        [_labelContainerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:4];
        [_labelContainerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:4];
        [_labelContainerView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [_labelContainerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_artworkImageView withOffset:marginInset()];
//            [_titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_artworkImageView withOffset:marginInset()];
//            [_albumArtistLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_artworkImageView withOffset:marginInset()];
        }];
    }];
    [self.contentView addConstraints:constraints];
}


/**
 *  Return text label.
 *
 *  @return text label.
 */
- (UILabel *)textLabel{
    return _titleLabel;
}

/**
 *  Return album label.
 *
 *  @return album label
 */
- (UILabel *)detailTextLabel{
    return _albumArtistLabel;
}

/**
 *  Return artwork instead of inbuilt image view.
 *
 *  @return artwork instead of inbuilt image view.
 */
- (UIImageView *)imageView{
    return _artworkImageView;
}

/**
 *  Updates layout to reflect the playback state
 */
- (void)_updateLayoutToPlayingState{
    if (_playing) {
        _indicatorView = [[NIFNowPlayingIndicatorView alloc] initWithFrame:CGRectZero];
        [_indicatorView sizeToFit];
        _indicatorView.playbackState = [[NIFMusicPlayerController sharedInstance] playbackState];
        self.accessoryView = _indicatorView;
    }else{
        self.accessoryView = nil;
        _indicatorView = nil;
    }
}

/**
 *  Sets the playback state of the current cell
 *
 *  @param playing the playback state, corresponding to the current playing item and it's queue.
 */
- (void)setPlaying:(BOOL)playing{
    _playing = playing;
    [self _updateLayoutToPlayingState];
}

/**
 *  The now playing indicator view.
 *
 *  @return the now playing indicator view.
 */
- (NIFNowPlayingIndicatorView *)nowPlayingIndicator{
    return _indicatorView;
}

@end
