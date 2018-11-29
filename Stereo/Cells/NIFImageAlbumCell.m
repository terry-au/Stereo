//
//  NIFImageAlbumCell.m
//  Stereo
//
//  Created by Terry Lewis on 16/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFImageAlbumCell.h"

@implementation NIFImageAlbumCell{
    UIImageView *_artworkImageView;
    UILabel *_albumLabel;
    UILabel *_artistLabel;
}

/**
 *  Sets up the views
 */
- (void)setupViews{
    _artworkImageView = [UIImageView newAutoLayoutView];
    _artworkImageView.contentMode = UIViewContentModeScaleAspectFit;
    _albumLabel = [UILabel newAutoLayoutView];
    _albumLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _artistLabel = [UILabel newAutoLayoutView];
    _artistLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [self.contentView addSubview:_artworkImageView];
    [self.contentView addSubview:_albumLabel];
    [self.contentView addSubview:_artistLabel];
}

/**
 *  Sets up the constraints
 */
- (void)setupConstraints{
    NSArray *constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        [_artworkImageView autoPinEdgesToSuperviewEdgesWithInsets:thinMarginInsets() excludingEdge:ALEdgeRight];
        [_artworkImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_artworkImageView];
        
        [_albumLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginInset()];
        [_albumLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_artworkImageView withOffset:marginInset()];
        [_albumLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:marginInset()];
        [_artistLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginInset()];
        [_artistLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_artworkImageView withOffset:marginInset()];
        [_artistLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:marginInset()];
        [_artistLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_albumLabel withOffset:thinMarginInset() relation:NSLayoutRelationGreaterThanOrEqual];
    }];
    [self.contentView addConstraints:constraints];
}

/**
 *  Returns artwork image view
 *
 *  @return artwork image view
 */
- (UIImageView *)imageView{
    return _artworkImageView;
}

/**
 *  Returns album label
 *
 *  @return album label
 */
- (UILabel *)textLabel{
    return _albumLabel;
}

/**
 *  Returns artist label
 *
 *  @return artist label
 */
- (UILabel *)detailTextLabel{
    return _artistLabel;
}

@end
