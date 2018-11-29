//
//  NIFSharedMethods.h
//  Stereo
//
//  Created by Terry Lewis on 20/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIFSharedMethods : NSObject

/**
 *  Creates an attributed string suitable for song cells.
 *
 *  @param artist artist name
 *  @param album  album name
 *
 *  @return instance of attributed string, with attributes for provided text
 */
+ (NSAttributedString *)attributedStringForArtist:(NSString *)artist album:(NSString *)album;

/**
 *  Returns a string representation of a track number. If 0, nil is returned.
 *
 *  @param trackNumber the track number.
 *
 *  @return A string representing the track number.
 */
+ (NSString *)stringFromTrackNumber:(NSUInteger)trackNumber;

@end
