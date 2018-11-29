//
//  MPMediaItem-Stereo.h
//  Stereo
//
//  Created by Terry Lewis on 8/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPMediaItem (Stereo)

/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)composerSafety;
/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)artistSafety;
/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)albumArtistSafety;
/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)albumSafety;
/**
 *  Returns an "UNKNOWN_*" string if the field is unset on the media item. Allows sorting via UILocalizedCollation, which would otherwise crash if a null value is passed.
 *
 *  @return a guaranteed non-null value.
 */
- (NSString *)titleSafety;

@end
