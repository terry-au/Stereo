//
//  NIFImageArtistCell.h
//  Stereo
//
//  Created by Terry Lewis on 8/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFImageSongCell.h"

@interface NIFImageArtistCell : NIFImageSongCell

/**
 *  Sets the number of albums and songs label, pertaining to the item that this cell represents.
 *
 *  @param albumsCount the number of albums.
 *  @param songsCount  the number of songs.
 */
- (void)setAlbumsCount:(NSUInteger)albumsCount songsCount:(NSUInteger)songsCount;

@end
