//
//  NIFConstants.m
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFConstants.h"

/**
 *  Group identifier strings
 */

//NSString * const NIFMediaPlaybackGroupPlaylist = @"NIFMediaPlaybackGroupPlayList";
//NSString * const NIFMediaPlaybackGroupArtist = @"NIFMediaPlaybackGroupArtist";
//NSString * const NIFMediaPlaybackGroupAlbumInArtist = @"NIFMediaPlaybackGroupAlbumInArtist";
//NSString * const NIFMediaPlaybackGroupAlbum = @"NIFMediaPlaybackGroupAlbum";
//NSString * const NIFMediaPlaybackGroupSong = @"NIFMediaPlaybackGroupSong";
//NSString * const NIFMediaPlaybackGroupGenre = @"NIFMediaPlaybackGroupGenre";
//NSString * const NIFMediaPlaybackGroupCompilation = @"NIFMediaPlaybackGroupCompilation";
//NSString * const NIFMediaPlaybackGroupComposer = @"NIFMediaPlaybackGroupComposer";


/**
 *  Margin inset used throughout Stereo.
 *
 *  @return insets of 8.0f points
 */
UIEdgeInsets marginInsets(void){
    static UIEdgeInsets _marginInsets;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _marginInsets = UIEdgeInsetsMake(marginInset(), marginInset(), marginInset(), marginInset());
    });
    return _marginInsets;
}

/**
 *  Thin-margin inset used throughout Stereo.
 *
 *  @return insets of 4.0f points
 */
UIEdgeInsets thinMarginInsets(void){
    static UIEdgeInsets _thinMarginInsets;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _thinMarginInsets = UIEdgeInsetsMake(thinMarginInset(), thinMarginInset(), thinMarginInset(), thinMarginInset());
    });
    return _thinMarginInsets;
}

/**
 *  Thin-margin used throughout Stereo.
 *
 *  @return margin of 4.0f points
 */
CGFloat thinMarginInset(void){
    return 4.0f;
}

/**
 *  Margin used throughout Stereo.
 *
 *  @return margin of 8.0f points
 */
CGFloat marginInset(void){
    return 8.0f;
}

/**
 *  Generates a time interval in HH:mm:ss from a number of seconds.
 *
 *  @param interval interval (seconds)
 *
 *  @return formatted string
 */
NSString *stringFromTimeInterval(NSTimeInterval interval){
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    NSInteger days = (ti / 86400);
    
    if (days) {
        return [NSString stringWithFormat:@"%ld:%02ld:02%ld:%02ld", (long)days, (long)hours, (long)minutes, (long)seconds];
    }else if (hours){
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    }else{
        return [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
    }
}

@implementation NIFConstants

@end
