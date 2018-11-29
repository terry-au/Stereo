//
//  NIFMusicManager.m
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFMusicManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSMutableDictionary+Stereo.h"
#import "NIFMediaCollator.h"

@interface NIFMusicManager ()
@end

@implementation NIFMusicManager{
    MPMediaLibrary *_library;
    MPMediaQuery *_query;
    NIFMediaCollator *_mediaCollator;
}

//@synthesize collation;

/**
 *  Stops generating library change notifications.
 */
- (void)dealloc{
    [_library endGeneratingLibraryChangeNotifications];
}

/**
 *  Singleton of music manager.
 *
 *  @return the music manager.
 */
+ (instancetype)sharedManager{
    static NIFMusicManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NIFMusicManager alloc] init];
    });
    return sharedManager;
}

/**
 *  The shared player controller.
 *
 *  @return the sharedInstance of the player controller.
 */
+ (NIFMusicPlayerController *)playerController{
    return [NIFMusicPlayerController sharedInstance];
}

/**
 *  Initialises and configures the music manager.
 *
 *  @return the configured music manager.
 */
- (instancetype)init{
    self = [super init];
    if (self) {
        _mediaCollator = [NIFMediaCollator sharedCollator];
        _library = [MPMediaLibrary defaultMediaLibrary];
        [_library beginGeneratingLibraryChangeNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMediaLibraryChanged:) name:MPMediaLibraryDidChangeNotification object:nil];
        _query = [[MPMediaQuery alloc] init];
    }
    return self;
}

/**
 *  Handle's changes to music library. Should destroy caches and issue refreshes to all table views.
 *
 *  @param aNotification notification.
 */
- (void)handleMediaLibraryChanged:(NSNotification *)aNotification{
//    handle change to media library
    _playlists = _artists = _songs = _albums = _genres = _compilations = _composers = nil;
    _artistInformation = nil;
}

/**
 *  Array of MPMediaItems pertaining to each artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)artists{
    [self setArray:&_artists usingSelector:@selector(artistsQuery)];
    return _artists;
}

/**
 *  Array of MPMediaItems pertaining to each album artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)albumArtists{
    MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
    NSArray *artists = [_mediaCollator deriveRepresentativeItemsFromQuery:artistsQuery withGrouping:MPMediaGroupingAlbumArtist];
    return artists;
}

/**
 *  Array of MPMediaItems pertaining to each song.
 *
 *  @return the array of media items.
 */
- (NSArray *)songs{
    [self setArray:&_songs usingSelector:@selector(songsQuery)];
    return _songs;
}

/**
 *  Array of MPMediaItems pertaining to each album.
 *
 *  @return the array of media items.
 */
- (NSArray *)albums{
    [self setArray:&_albums usingSelector:@selector(albumsQuery)];
    return _albums;
}

/**
 *  Array of MPMediaItems pertaining to each genre.
 *
 *  @return the array of media items.
 */
- (NSArray *)genres{
    [self setArray:&_genres usingSelector:@selector(genresQuery)];
    return _genres;
}

/**
 *  Array of MPMediaItems pertaining to each playlist.
 *
 *  @return the array of media items.
 */
- (NSArray *)playlists{
    MPMediaQuery *playlistsQuery = MPMediaQuery.playlistsQuery;
    return playlistsQuery.collections;
}

/**
 *  Array of MPMediaItems pertaining to each composer.
 *
 *  @return the array of media items.
 */
- (NSArray *)composers{
    [self setArray:&_composers usingSelector:@selector(composersQuery)];
    return _composers;
}

/**
 *  Array of MPMediaItems pertaining to each compilation.
 *
 *  @return the array of media items.
 */
- (NSArray *)compilations{
    [self setArray:&_compilations usingSelector:@selector(compilationsQuery)];
    return _compilations;
}

/**
 *  Array of MPMediaItems pertaining to each album for a given artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)albumsForArtist:(NSString *)artist{
    return [self query:@selector(albumsQuery) withValue:artist forKey:MPMediaItemPropertyArtistPersistentID];
}

/**
 *  Array of MPMediaItems pertaining to each album for a given album artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)albumsForAlbumArtist:(NSString *)albumArtist{
    return [self query:@selector(albumsQuery) withValue:albumArtist forKey:MPMediaItemPropertyAlbumArtistPersistentID];
}

/**
 *  Array of MPMediaItems pertaining to each song for a given artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForArtist:(NSString *)artist{
    return [self query:@selector(songsQuery) withValue:artist forKey:MPMediaItemPropertyArtistPersistentID];
}

/**
 *  Array of MPMediaItems pertaining to each song for a given artist.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForAlbumArtist:(NSString *)artist{
    return [self query:@selector(songsQuery) withValue:artist forKey:MPMediaItemPropertyAlbumArtistPersistentID];
}

/**
 *  Array of MPMediaItems pertaining to each song for a given album.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForAlbum:(NSString *)album{
    return [self query:@selector(songsQuery) withValue:album forKey:MPMediaItemPropertyAlbumPersistentID];
}

/**
 *  Returns the songs for an artist in a given album.
 *
 *  @param artist the artist's persistent identifier.
 *  @param album  the album's persistent identifier.
 *
 *  @return an array of media items.
 */
- (NSArray *)songsForArtist:(NSString *)artist inAlbum:(NSString *)album{
    NSArray *songsInAlbum = [self query:@selector(songsQuery) withValue:album forKey:MPMediaItemPropertyAlbumPersistentID];
    NSArray *songsInAlbumForArtist = [songsInAlbum filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(MPMediaItem *_Nonnull mediaItem, NSDictionary * _Nullable bindings) {
    
        return [[mediaItem valueForProperty:MPMediaItemPropertyArtistPersistentID] isEqualToNumber:(NSNumber *)artist];
    }]];
    return songsInAlbumForArtist;
}

/**
 *  Array of MPMediaItems pertaining to each song for a given genre.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForGenre:(NSString *)genre{
    return [self query:@selector(songsQuery) withValue:genre forKey:MPMediaItemPropertyGenrePersistentID];
}

/**
 *  Array of MPMediaItems pertaining to each song for a given compilation.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForCompilation:(NSString *)compilation{
    return [self songsForAlbum:compilation];
}

/**
 *  Array of MPMediaItems pertaining to each song for a given composer.
 *
 *  @return the array of media items.
 */
- (NSArray *)songsForComposer:(NSString *)composer{
    return [self query:@selector(songsQuery) withValue:composer forKey:MPMediaItemPropertyComposerPersistentID];
}

/**
 *  Assigns an array to values derived from a given media selector.
 *
 *  @param array         array
 *  @param mediaSelector selector that returns array.
 */
- (void)setArray:(__strong NSArray **)array usingSelector:(SEL)mediaSelector{
    if (*array != nil) {
        return;
    }
    static int i = 0;
    i++;
//    NSLog(@"ARRAY: %p for %i", array, i);
    MPMediaQuery *allAlbumsQuery = [MPMediaQuery performSelector:mediaSelector];
    NSMutableArray *setupArray = [self representativeArrayFromQuery:allAlbumsQuery];
//    [self setValue:setupArray forKey:@"_songs"];
    *array = setupArray;
//    NSLog(@"%@->%@", NSStringFromSelector(mediaSelector), *array);
}

/**
 *  Generates an array of MPMediaItems by obtaining each items representativeItem.
 *
 *  @param query query of items.
 *
 *  @return the array of representative items.
 */
- (NSMutableArray *)representativeArrayFromQuery:(MPMediaQuery *)query{
    NSMutableArray *setupArray = [NSMutableArray array];
    NSArray *allAlbumsArray = [query collections];
    for (MPMediaItemCollection *collection in allAlbumsArray) {
        MPMediaItem *item = [collection representativeItem];
        [setupArray addObject:item];
    }
    return setupArray;
}

/**
 *  Performs a query with a supplied predicate.
 *
 *  @param selector  selector name of the query
 *  @param predicate predicate
 *
 *  @return array of media items that matched predicate.
 */
- (NSArray *)query:(SEL)selector withPredicate:(MPMediaPropertyPredicate *)predicate{
    MPMediaQuery *genericQuery = [MPMediaQuery performSelector:selector];
    [genericQuery addFilterPredicate:predicate];
    return [self representativeArrayFromQuery:genericQuery];
}

/**
 *  Performs a query where the key field is equal to the value. This is used to construct a predicate for the output of the query selector, of which items matching the predicate are returned.
 *
 *  @param selector the query selector.
 *  @param value    value to be matched
 *  @param key      field to match value to
 *
 *  @return array of media items that matched the predicate
 */
- (NSArray *)query:(SEL)selector withValue:(NSString *)value forKey:(NSString *)key{
    return [self query:selector withPredicate:[MPMediaPropertyPredicate predicateWithValue:value
                                                                               forProperty:key]];
}

/**
 *  Destroys the cached artist information.
 */
- (void)refreshArtistInformation{
    _artistInformation = nil;
}

- (NSDictionary *)artistInformation{
    if (_artistInformation) {
        return _artistInformation;
    }

    BOOL groupByAlbumArtist = [NIFSharedSettingsManager groupByAlbumArtist];
    NSString *identifier = groupByAlbumArtist ? MPMediaItemPropertyAlbumArtistPersistentID : MPMediaItemPropertyArtistPersistentID;
    NSArray *artists = groupByAlbumArtist ? [self albumArtists] : [self artists];
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    for (MPMediaItem *item in artists) {
        NSString *artistIdentifier = [item valueForProperty:identifier];
        NSArray *songsArray = groupByAlbumArtist ? [self songsForAlbumArtist:artistIdentifier] : [self songsForArtist:artistIdentifier];
        NSArray *albumsArray = groupByAlbumArtist ? [self albumsForAlbumArtist:artistIdentifier] : [self albumsForArtist:artistIdentifier];
        [returnDictionary setObject:@{@"songs" : @([songsArray count]), @"albums" : @([albumsArray count])} forKey:artistIdentifier];
    }
    _artistInformation = returnDictionary;
    return _artistInformation;
}


///**
// *  Returns a dictionary of information about artists, includes information such as number of albums and total number of songs.
// *
// *  @return a dictionary of artist information, keys are the persistent identifiers for artist or album artist.
// */
//- (NSDictionary *)artistInformation{
//    if (_artistInformation) {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            NSLog(@"%@", [self tmp_artistInformation]);
//        });
//        return _artistInformation;
//    }
//    
//    MPMediaQuery *albumQuery = [MPMediaQuery albumsQuery];
//    NSArray *albumCollection = [albumQuery collections];
//    NSCountedSet *artistAlbumCounter = [NSCountedSet set];
//    NSString *identifier = [NIFSharedSettingsManager groupByAlbumArtist] ? MPMediaItemPropertyAlbumArtistPersistentID : MPMediaItemPropertyArtistPersistentID;
//    
//    [albumCollection enumerateObjectsUsingBlock:^(MPMediaItemCollection *album, NSUInteger idx, BOOL *stop) {
//        MPMediaItem *representativeItem = [album representativeItem];
//        NSNumber *artistName = [representativeItem valueForProperty:identifier];
//        if (artistName != nil)
//        {
//            [artistAlbumCounter addObject:artistName];
//        }
//    }];
//    
//    NSMutableDictionary *dictArray = [NSMutableDictionary dictionary];
//    [artistAlbumCounter enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
//        if (obj)
//        {
//            [dictArray setObject:[NSMutableDictionary dictionaryWithObjects:@[@([artistAlbumCounter countForObject:obj])]
//                                                                              forKeys:@[@"albums"]]
//                          forKey:obj];
//        }
//    }];
//    
//    MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
//    NSArray *songCollection = [songQuery collections];
//    NSCountedSet *artistSongCounter = [NSCountedSet set];
//    
//    [songCollection enumerateObjectsUsingBlock:^(MPMediaItemCollection *song, NSUInteger idx, BOOL *stop) {
//        MPMediaItem *representativeItem = [song representativeItem];
//        NSNumber *artistName = [representativeItem valueForProperty:identifier];
//        if (artistName)
//        {
//            [artistSongCounter addObject:artistName];
//        }
//    }];
//    
//    [artistSongCounter enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
//        NSNumber *count = @([artistSongCounter countForObject:obj]);
//        if (obj && count)
//        {
//            NSMutableDictionary *dict = [dictArray objectForKey:obj];
//            [dict setObject:count forKey:@"songs"];
//        }
//    }];
//    _artistInformation = dictArray;
//    return _artistInformation;
//}

/**
 *  Returns the number of albums for a given artist
 *
 *  @param artist the persistent id of the artist
 *
 *  @return the number of albums for the given artist
 */
- (NSInteger)numberOfAlbumsForArtist:(NSString *)artist{
    return [[[[self artistInformation] objectForKey:artist] objectForKey:@"albums"] integerValue];
}

/**
 *  Returns the number of songs for a given artist
 *
 *  @param artist the persistent id of the artist
 *
 *  @return the number of songs for the given artist
 */
- (NSInteger)numberOfSongsForArtist:(NSString *)artist{
    return [[[[self artistInformation] objectForKey:artist] objectForKey:@"songs"] integerValue];
}

@end
