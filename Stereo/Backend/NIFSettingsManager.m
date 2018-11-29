//
//  NIFSettingsManager.m
//  Stereo
//
//  Created by Terry Lewis on 20/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFSettingsManager.h"

@implementation NIFSettingsManager{
    NSUserDefaults *_defaults;
}

+ (instancetype)sharedSettingsManager{
    static NIFSettingsManager *sharedSettingsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettingsManager = [[NIFSettingsManager alloc] init];
    });
    return sharedSettingsManager;
}

static NSString *kNIFRepeatModeSettingsKey = @"NIFRepeatMode";
static NSString *kNIFShuffleModeSettingsKey = @"NIFShuffleMode";

- (instancetype)init{
    if (self = [super init]) {
        _defaults = [NSUserDefaults standardUserDefaults];
        _groupByAlbumArtist = YES;
        NSLog(@"%@", _defaults);
        
//        _repeatMode =
    }
    return self;
}

- (void)setRepeatMode:(MPMusicRepeatMode)repeatMode{
    [_defaults setInteger:repeatMode forKey:kNIFRepeatModeSettingsKey];
    [_defaults synchronize];
}

- (MPMusicRepeatMode)repeatMode{
    return [_defaults integerForKey:kNIFRepeatModeSettingsKey];
}

- (void)setShuffleMode:(MPMusicShuffleMode)shuffleMode{
    [_defaults setInteger:shuffleMode forKey:kNIFShuffleModeSettingsKey];
    [_defaults synchronize];
}

- (MPMusicShuffleMode)shuffleMode{
    return [_defaults integerForKey:kNIFShuffleModeSettingsKey];
}

//- (MPMusicRepeatMode)repeatMode{
//    return [[[NSUserDefaults standardUserDefaults] objectForKey:kNIFRepeatModeSettingsKey] integerValue];
//}

@end
