//
//  NIFDetailScrubber.h
//  Stereo
//
//  Created by Terry Lewis on 7/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "JGDetailScrubber.h"

@class NIFDetailScrubber;

/**
 *  Delegate that adds a callback for when scrubbing is completed.
 */
@protocol NIFDetailScrubberDelegate <JGDetailScrubberDelegate>

@optional
/**
 *  Indicates when scrubbing has been completed
 *
 *  @param slider the slider that finished scrubbing
 */
- (void)scrubberDidFinishScrubbing:(JGDetailScrubber *)slider;

@end

@interface NIFDetailScrubber : JGDetailScrubber

@property (nonatomic, weak) id <NIFDetailScrubberDelegate> delegate;

@end
