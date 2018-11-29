//
//  NIFSettingsManager.h
//  Stereo
//
//  Created by Terry Lewis on 20/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Manages application settings.
 */
@interface NIFSettingsManager : NSObject

#define NIFSharedSettingsManager [NIFSettingsManager sharedSettingsManager]

+ (instancetype)sharedSettingsManager;

/**
 *  Whether or not the artists view dervies data from the album artist metadata field.
 */
@property (nonatomic) BOOL groupByAlbumArtist;
@property (nonatomic) MPMusicRepeatMode repeatMode;
@property (nonatomic) MPMusicShuffleMode shuffleMode;

@end