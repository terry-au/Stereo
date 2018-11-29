//
//  NIFNowPlayingDeepState.m
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFNowPlayingDeepState.h"

@implementation NIFNowPlayingDeepState

/**
 *  Singleton of this class.
 *
 *  @return returns a shared instance
 */
+ (instancetype)sharedInstance{
    static NIFNowPlayingDeepState *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NIFNowPlayingDeepState alloc] init];
    });
    return sharedInstance;
}

/**
 *  Determines whether or not a provided identifier matches the now playing identifier.
 *
 *  @param identifierMatches the identifier to match
 *
 *  @return whether or not the provided details match
 */
- (BOOL)identifierMatches:(MPMediaEntityPersistentID)identifier{
    return identifier == [NIFMusicManager playerController].nowPlayingItem.persistentID;
}

/**
 *  Determines whether or not a provided identifier matches the now playing identifier.
 *
 *  @param identifierMatches the identifier to match
 *  @param group             the playback group
 *
 *  @return whether or not the provided details match
 */
- (BOOL)identifierMatches:(MPMediaEntityPersistentID)identifier inGroup:(NIFMediaPlaybackGroup)group{
    return [self identifierMatches:identifier] && group == _playbackGroup;
}

/**
 *  Determines whether or not a provided identifier matches the now playing identifier.
 *
 *  @param identifierMatches the identifier to match
 *  @param group             the playback group
 *  @param playlist          the playlist identifier
 *
 *  @return whether or not the provided details match
 */
- (BOOL)identifierMatches:(MPMediaEntityPersistentID)identifier inGroup:(NIFMediaPlaybackGroup)group inPlaylist:(MPMediaEntityPersistentID)playlist{
//    NSLog(@"IdentifierA: %@\nIdentifierB: %@\nGroupA: %@\nGroupB: %@\nPlaylistA: %@\nPlaylistB: %@", [self friendlyStringFromIdentifier:identifier], [self friendlyStringFromIdentifier:[NIFMusicManager playerController].nowPlayingItem.persistentID], group, _playbackGroup, [self friendlyStringFromIdentifier:playlist], [self friendlyPlaylistIdentifier]);
    return [self identifierMatches:identifier inGroup:group] && playlist == _playlistIdentifier;
}

/**
 *  Sets the playback group
 *
 *  @param playbackGroup playback group to set to
 */
- (void)setPlaybackGroup:(NIFMediaPlaybackGroup)playbackGroup{
    _playbackGroup = playbackGroup;
    if (playbackGroup != NIFMediaPlaybackGroupPlaylist) {
        _playlistIdentifier = NSNotFound;
    }
}


/**
 *  Returns a friendly, stringified identifier for the provided identifier, used in description.
 *
 *  @return friendly identifier
 */
- (NSString *)friendlyStringFromIdentifier:(MPMediaEntityPersistentID)identifier{
    if (identifier == NSNotFound) {
        return @"None";
    }
    
    return [NSString stringWithFormat:@"%llu", identifier];
}

/**
 *  Returns a friendly identifier for the playlist, used in description.
 *
 *  @return friendly identifier
 */
- (NSString *)friendlyPlaylistIdentifier{
    return [self friendlyStringFromIdentifier: _playlistIdentifier];
}

/**
 *  Returns a description of the state.
 *
 *  @return description, including properties.
 */
- (NSString *)description{
    return [NSString stringWithFormat:@"%@\nPlayback Group: %i\nPlaylist Identifier: %@", [super description], _playbackGroup, [self friendlyPlaylistIdentifier]];
}

@end
