//
//  NIFImageArtistCell.m
//  Stereo
//
//  Created by Terry Lewis on 8/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFImageArtistCell.h"

@implementation NIFImageArtistCell

/**
 *  Generates a string using the inputted data.
 *
 *  @param albumsCount number of albums.
 *  @param songsCount  number of songs.
 *
 *  @return string, formatted and containing the inputted data.
 */
- (NSString *)stringForAlbumsCount:(NSUInteger)albumsCount songsCount:(NSUInteger)songsCount{
    if (songsCount == 1 && albumsCount == 1) {
        return NIFLocStr(@"ALBUM_SONGS_COUNT_FORMAT_1_ALBUM_1_SONG");
    }else if (albumsCount == 1 && songsCount != 1){
        return [NSString stringWithFormat:NIFLocStr(@"ALBUM_SONGS_COUNT_FORMAT_1_ALBUM_X_SONGS"), (long)songsCount];
    }else if (songsCount == 1 && albumsCount != 1){
        return [NSString stringWithFormat:NIFLocStr(@"ALBUM_SONGS_COUNT_FORMAT_X_ALBUMS_1_SONG"), (long)albumsCount];
    }else{
        return [NSString stringWithFormat:NIFLocStr(@"ALBUM_SONGS_COUNT_FORMAT_X_ALBUMS_Y_SONGS"), (long)albumsCount, (long)songsCount];
    }
}

/**
 *  Sets the number of albums and songs label, pertaining to the item that this cell represents.
 *
 *  @param albumsCount the number of albums.
 *  @param songsCount  the number of songs.
 */
- (void)setAlbumsCount:(NSUInteger)albumsCount songsCount:(NSUInteger)songsCount{
    self.detailTextLabel.text = [self stringForAlbumsCount:albumsCount songsCount:songsCount];
}

@end
