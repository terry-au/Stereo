//
//  NIFMusicManager.h
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMediaItem-Stereo.h"
#import "NIFMusicPlayerController.h"
#import "NIFMediaCollator.h"

@interface NIFMusicManager : NSObject{
    NSArray *_playlists, *_artists, *_songs, *_albums, *_genres, *_compilations, *_composers;
    NSDictionary *_artistInformation;
}

#define sharedMusicManager [NIFMusicManager sharedManager]

/**
 *  Singleton of music manager.
 *
 *  @return the music manager.
 */
+ (instancetype)sharedManager;

/**
 *  The shared player controller.
 *
 *  @return the sharedInstance of the player controller.
 */
+ (NIFMusicPlayerController *)playerController;

/**
 *  Array of MPMediaItems pertaining to each artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)artists;
/**
 *  Array of MPMediaItems pertaining to each album artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)albumArtists;
/**
 *  Array of MPMediaItems pertaining to each song.
 *
 *  @return the array of media items.
 */
- (NSArray *)songs;
/**
 *  Array of MPMediaItems pertaining to each album.
 *
 *  @return the array of media items.
 */
- (NSArray *)albums;
/**
 *  Array of MPMediaItems pertaining to each genre.
 *
 *  @return the array of media items.
 */
- (NSArray *)genres;
/**
 *  Array of MPMediaItems pertaining to each playlist.
 *
 *  @return the array of media items.
 */
- (NSArray *)playlists;
/**
 *  Array of MPMediaItems pertaining to each composer.
 *
 *  @return the array of media items.
 */
- (NSArray *)composers;
/**
 *  Array of MPMediaItems pertaining to each compilation.
 *
 *  @return the array of media items.
 */
- (NSArray *)compilations;

/**
 *  Array of MPMediaItems pertaining to each album for a given artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)albumsForArtist:(NSString *)artist;
/**
 *  Array of MPMediaItems pertaining to each album for a given album artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)albumsForAlbumArtist:(NSString *)albumArtist;

/**
 *  Array of MPMediaItems pertaining to each song for a given artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForArtist:(NSString *)artist;
/**
 *  Array of MPMediaItems pertaining to each song for a given artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForAlbumArtist:(NSString *)artist;
/**
 *  Array of MPMediaItems pertaining to each song for a given album.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForAlbum:(NSString *)album;
/**
 *  Returns the songs for an artist in a given album.
 *
 *  @param artist the artist's persistent identifier.
 *  @param album  the album's persistent identifier.
 *
 *  @return an array of media items.
 */
- (NSArray *)songsForArtist:(NSString *)artist inAlbum:(NSString *)album;
/**
 *  Array of MPMediaItems pertaining to each song for a given genre.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForGenre:(NSString *)genre;
/**
 *  Array of MPMediaItems pertaining to each song for a given compilation.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForCompilation:(NSString *)compilation;

/**
 *  Array of MPMediaItems pertaining to each song for a given composer.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForComposer:(NSString *)composer;

/**
 *  Returns the number of albums for a given artist
 *
 *  @param artist the persistent id of the artist
 *
 *  @return the number of albums for the given artist
 */
- (NSInteger)numberOfAlbumsForArtist:(NSString *)artist;
/**
 *  Returns the number of songs for a given artist
 *
 *  @param artist the persistent id of the artist
 *
 *  @return the number of songs for the given artist
 */
- (NSInteger)numberOfSongsForArtist:(NSString *)artist;

/**
 *  Destroys the cached artist information.
 */
- (void)refreshArtistInformation;

//@property (nonatomic, readonly) UILocalizedIndexedCollation *collation;

@end
