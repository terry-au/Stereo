//
//  NIFDetailScrubber.m
//  Stereo
//
//  Created by Terry Lewis on 7/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFDetailScrubber.h"

@interface JGDetailScrubber (Private)

- (void)finishScrubbing;

@end

@implementation NIFDetailScrubber

@dynamic delegate;

/**
 *  Indicates when scrubbing is finished and notifies the delegate of such things.
 */
- (void)finishScrubbing{
    [super finishScrubbing];
    if ([self.delegate respondsToSelector:@selector(scrubberDidFinishScrubbing:)]) {
        [self.delegate scrubberDidFinishScrubbing:self];
    }
    
}

@end
