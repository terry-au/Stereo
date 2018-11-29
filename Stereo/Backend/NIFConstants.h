//
//  NIFConstants.h
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Stereo_NIFConstants_h
#define Stereo_NIFConstants_h


/**
 *  Group identifier strings
 */

//extern NSString * const NIFMediaPlaybackGroupPlaylist;
//extern NSString * const NIFMediaPlaybackGroupArtist;
//extern NSString * const NIFMediaPlaybackGroupAlbumInArtist;
//extern NSString * const NIFMediaPlaybackGroupAlbum;
//extern NSString * const NIFMediaPlaybackGroupSong;
//extern NSString * const NIFMediaPlaybackGroupGenre;
//extern NSString * const NIFMediaPlaybackGroupCompilation;
//extern NSString * const NIFMediaPlaybackGroupComposer;

typedef enum{
    NIFMediaPlaybackGroupPlaylist,
    NIFMediaPlaybackGroupArtist,
    NIFMediaPlaybackGroupAlbumInArtist,
    NIFMediaPlaybackGroupAlbum,
    NIFMediaPlaybackGroupSong,
    NIFMediaPlaybackGroupGenre,
    NIFMediaPlaybackGroupCompilation,
    NIFMediaPlaybackGroupComposer,
} NIFMediaPlaybackGroup;

/**
 *  Margin inset used throughout Stereo.
 *
 *  @return insets of 8.0f points
 */
UIEdgeInsets marginInsets(void);

/**
 *  Thin-margin inset used throughout Stereo.
 *
 *  @return insets of 4.0f points
 */
CGFloat marginInset(void);

/**
 *  Thin-margin used throughout Stereo.
 *
 *  @return margin of 4.0f points
 */
CGFloat thinMarginInset(void);

/**
 *  Margin used throughout Stereo.
 *
 *  @return margin of 8.0f points
 */
UIEdgeInsets thinMarginInsets(void);

/**
 *  Generates a time interval in HH:mm:ss from a number of seconds.
 *
 *  @param interval interval (seconds)
 *
 *  @return formatted string
 */
NSString *stringFromTimeInterval(NSTimeInterval interval);

#endif

@interface NIFConstants : NSObject

@end
