//
//  NIFNowPlayingDeepState.h
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  I had no idea what to call this class.
 *  The basic idea: if this class began playing music using a genre, it will know, if it was just from "all songs" it will also know.
 *  This is required in order to accurately display the playing indicator in the table view cell of the currently playing item.
 */
@interface NIFNowPlayingDeepState : NSObject

/**
 *  The playback group
 */
@property (nonatomic) NIFMediaPlaybackGroup playbackGroup;
//@property (nonatomic, strong) NSString *playbackGroup;
/**
 *  The identifier of the now playing song.
 */
@property (nonatomic) MPMediaEntityPersistentID nowPlayingSongIdentifier;
/**
 *  The identifier of the now playing playlist (is any)
 */
@property (nonatomic) MPMediaEntityPersistentID playlistIdentifier;

/**
 *  Singleton of this class.
 *
 *  @return returns a shared instance
 */
+ (instancetype)sharedInstance;

/**
 *  Determines whether or not a provided identifier matches the now playing identifier.
 *
 *  @param identifierMatches the identifier to match
 *
 *  @return whether or not the provided details match
 */
- (BOOL)identifierMatches:(MPMediaEntityPersistentID)identifier;

/**
 *  Determines whether or not a provided identifier matches the now playing identifier.
 *
 *  @param identifierMatches the identifier to match
 *  @param group             the playback group
 *
 *  @return whether or not the provided details match
 */
- (BOOL)identifierMatches:(MPMediaEntityPersistentID)identifierMatches inGroup:(NIFMediaPlaybackGroup)group;

/**
 *  Determines whether or not a provided identifier matches the now playing identifier.
 *
 *  @param identifierMatches the identifier to match
 *  @param group             the playback group
 *  @param playlist          the playlist identifier
 *
 *  @return whether or not the provided details match
 */
- (BOOL)identifierMatches:(MPMediaEntityPersistentID)identifier inGroup:(NIFMediaPlaybackGroup)group inPlaylist:(MPMediaEntityPersistentID)playlist;

@end
