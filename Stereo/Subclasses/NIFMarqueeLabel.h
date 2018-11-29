//
//  NIFMarqueeLabel.h
//  Stereo
//
//  Created by Terry Lewis on 7/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "MarqueeLabel.h"

@class NIFMarqueeLabel;

@protocol NIFMarqueeLabelDelegate <NSObject>

- (void)marqueeLabelDidFinishScrolling:(NIFMarqueeLabel *)marqueeLabel;
- (void)marqueeLabelWillBeginScrolling:(NIFMarqueeLabel *)marqueeLabel;

@end

@interface NIFMarqueeLabel : MarqueeLabel

@property (nonatomic, assign) id<NIFMarqueeLabelDelegate> delegate;

/**
 *  Whether the label was paused
 */
@property (nonatomic) BOOL oldStateWasPaused;

/**
 *  Pauses label and saves its animation state
 */
- (void)pauseLabelSavingState;

/**
 *  Returns label to saved animation state
 */
- (void)returnToOldState;

/**
 *  Whether the label fits all of the text in with or without scrolling.
 */
@property (nonatomic, assign, readonly) BOOL labelWillScrollIfNecessary;

@end
