//
//  NIFSongCell.m
//  Stereo
//
//  Created by Terry Lewis on 28/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFSongCell.h"
#import "NIFNowPlayingIndicatorView.h"
#import "UIFont+MonospaceCompat.h"

@implementation NIFSongCell{
    NIFNowPlayingIndicatorView *_indicatorView;
    UIView *_leftAccessoryView;
    NSArray *_indicatorConstraints;
    NSArray *_trackNumberConstraints;
    UIView *_indicatorHostView;
    NSLayoutConstraint *_leftAccessoryViewConstraint;
}

/**
 *  Sets up the views.
 */
- (void)setupViews{
    static UIFont *monospaceFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monospaceFont = [[UIFont systemFontOfSize:14.0f] monospaceFontVariant];
    });
    
    _trackNumberLabel = [UILabel newAutoLayoutView];
    _trackNumberLabel.textAlignment = NSTextAlignmentCenter;
    _trackNumberLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel = [UILabel newAutoLayoutView];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _durationLabel = [UILabel newAutoLayoutView];
    _durationLabel.font = monospaceFont;
    _leftAccessoryView = [UIView newAutoLayoutView];
    _indicatorView = [NIFNowPlayingIndicatorView newAutoLayoutView];
    _indicatorHostView = [UIView newAutoLayoutView];
    [_leftAccessoryView addSubview:_trackNumberLabel];
    [_indicatorHostView addSubview:_indicatorView];
    [_leftAccessoryView addSubview:_indicatorHostView];
    [self.contentView addSubview:_leftAccessoryView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_durationLabel];
}

static const CGFloat kFullSizeAccessoryWidth = 30.0f;
static const CGFloat kMinimalSizeAccessoryWidth = 10.0f;

/**
 *  Sets up the constraints.
 */
- (void)setupConstraints{
    [_durationLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_trackNumberLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_indicatorHostView addConstraints:[UIView autoCreateConstraintsWithoutInstalling:^{
        [_indicatorView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }]];
    NSArray *leftConstraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        [_trackNumberLabel autoCenterInSuperview];
        [_indicatorHostView autoCenterInSuperview];
        [_indicatorHostView autoSetDimensionsToSize:CGSizeMake(12, 13)];
    }];
    [_leftAccessoryView addConstraints:leftConstraints];
    
    NSArray *constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        [_leftAccessoryView autoPinEdgesToSuperviewEdgesWithInsets:marginInsets() excludingEdge:ALEdgeRight];
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            _leftAccessoryViewConstraint = [_leftAccessoryView autoSetDimension:ALDimensionWidth toSize:kFullSizeAccessoryWidth relation:0];
            [_titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_leftAccessoryView withOffset:marginInset()];
            [_durationLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginInset()*2];
        }];
        
        [_titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_durationLabel withOffset:-marginInset() relation:NSLayoutRelationLessThanOrEqual];
        
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:marginInset()];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:marginInset()];
        
        [_durationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:marginInset()];
        [_durationLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:marginInset()];
    }];
    [self.contentView addConstraints:constraints];
}

/**
 *  Clears the text on all labels.
 */
- (void)prepareForReuse{
    _titleLabel.text = _durationLabel.text = _trackNumberLabel.text = @"";
}

/**
 *  Updates layout to reflect the playback state
 */
- (void)_updateLayoutToPlayingState{
    //    _indicatorView.center = _leftAccessoryView.center;
    if (_playing) {
        [_trackNumberLabel setHidden:YES];
        [_indicatorView setHidden:NO];
    }else{
        [_trackNumberLabel setHidden:NO];
        [_indicatorView setHidden:YES];
    }
    _indicatorView.playbackState = [NIFMusicPlayerController sharedInstance].playbackState;
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

- (void)setLeftAccessoryViewHidden:(BOOL)trackNumberLabelHidden{
    _leftAccessoryView.hidden = trackNumberLabelHidden;
    if (trackNumberLabelHidden) {
        _leftAccessoryViewConstraint.constant = kMinimalSizeAccessoryWidth;
    }else{
        _leftAccessoryViewConstraint.constant = kFullSizeAccessoryWidth;
    }
}

@end
