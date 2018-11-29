//
//  MPMediaItem-Stereo.m
//  Stereo
//
//  Created by Terry Lewis on 8/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "MPMediaItem-Stereo.h"

@implementation MPMediaItem (Stereo)

/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)albumSafety{
    if (self.albumTitle.length) {
        return [self albumTitle];
    }
    return [self albumFallback];
}
/**
 *  Fallback string to use if album is not found
 *
 *  @return the fallback string.
 */
- (NSString *)albumFallback{
    return NIFLocStr(@"UNKNOWN_ALBUM");
}

/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)albumArtistSafety{
    return [self albumArtist].length ? [self albumArtist] : [self albumArtistFallback];
}
/**
 *  Fallback string to use if album artist is not found
 *
 *  @return the fallback string.
 */
- (NSString *)albumArtistFallback{
    return NIFLocStr(@"UNKNOWN_ALBUM_ARTIST");
}

/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)artistSafety{
    return [self artist].length ? [self artist] : [self artistFallback];
}
/**
 *  Fallback string to use if artist is not found
 *
 *  @return the fallback string.
 */
- (NSString *)artistFallback{
    return NIFLocStr(@"UNKNOWN_ALBUM_ARTIST");
}

/**
 *  Fallback string to use if audiobook is not found
 *
 *  @return the fallback string.
 */
- (NSString *)audiobookFallback{
    return NIFLocStr(@"UNKNOWN_AUDIOBOOK");
}
/**
 *  Fallback string to use if compilation is not found
 *
 *  @return the fallback string.
 */
- (NSString *)compilationFallback{
    return NIFLocStr(@"UNKNOWN_COMPILATION");
}

/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)composerSafety{
    return [self composer].length ? [self composer] : [self composerFallback];
}
/**
 *  Fallback string to use if composer is not found
 *
 *  @return the fallback string.
 */
- (NSString *)composerFallback{
    return NIFLocStr(@"UNKNOWN_COMPOSER");
}

/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)genreSafety{
    return [self genre].length ? [self genre] : [self genreFallback];
}
/**
 *  Fallback string to use if genre is not found
 *
 *  @return the fallback string.
 */
- (NSString *)genreFallback{
    return NIFLocStr(@"UNKNOWN_GENRE");
}

/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)podcastSafety{
    return [self podcastTitle].length ? [self podcastTitle] : [self podcastFallback];
}
/**
 *  Fallback string to use if podcast is not found
 *
 *  @return the fallback string.
 */
- (NSString *)podcastFallback{
    return NIFLocStr(@"UNKNOWN_PODCAST");
}

/**
 *  Fallback string to use if podcast episode is not found
 *
 *  @return the fallback string.
 */
- (NSString *)podcastEpisodeFallback{
    return NIFLocStr(@"UNKNOWN_PODCAST_EPISODE");
}

/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)titleSafety{
    if (self.mediaType == MPMediaTypeAudioBook) {
        return [self title].length ? [self title] : [self audiobookFallback];
    }else if(self.isCompilation){
        return [self title].length ? [self title] : [self compilationFallback];
    }else if(self.mediaType == MPMediaTypePodcast){
        return [self title].length ? [self title] : [self podcastEpisodeFallback];
    }
    return [self title].length ? [self title] : [self titleFallback];
}

/**
 *  Fallback string to use if title is not found
 *
 *  @return the fallback string.
 */
- (NSString *)titleFallback{
    return NIFLocStr(@"UNKNOWN_TITLE");
}

@end