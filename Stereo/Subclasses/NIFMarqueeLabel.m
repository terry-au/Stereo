//
//  NIFMarqueeLabel.m
//  Stereo
//
//  Created by Terry Lewis on 7/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFMarqueeLabel.h"

@interface MarqueeLabel (Private)

@property (nonatomic, strong) UILabel *subLabel;
- (CGSize)subLabelSize;

@end

@implementation NIFMarqueeLabel


/**
 *  Called when the label returns to its original position, or when the scrollng animation is complete.
 *
 *  @param finished A Boolean that indicates whether or not the scroll animation actually finished before the completion handler was called.
 */
- (void)labelReturnedToHome:(BOOL)finished{
    [super labelReturnedToHome:finished];
    if (finished) {
        if ([self.delegate respondsToSelector:@selector(marqueeLabelDidFinishScrolling:)]) {
            [self.delegate marqueeLabelDidFinishScrolling:self];
        }
    }
}


/**
 *  Called when the label will begin to scroll.
 */
- (void)labelWillBeginScroll{
    [super labelWillBeginScroll];
    if ([self.delegate respondsToSelector:@selector(marqueeLabelWillBeginScrolling:)]) {
        [self.delegate marqueeLabelWillBeginScrolling:self];
    }
}

/**
 *  Pauses the label, saving the state.
 */
- (void)pauseLabelSavingState{
    _oldStateWasPaused = [self isPaused];
    [self pauseLabel];
}

/**
 *  Returns the scrolling state to the saved state.
 */
- (void)returnToOldState{
    if (_oldStateWasPaused) {
        [self pauseLabel];
    }else{
        [self unpauseLabel];
    }
}

/**
 *  Whether the label fits all of the text in with or without scrolling.
 *
 *  @return whether the label will scroll in order to show all of the text.
 */
- (BOOL)labelWillScrollIfNecessary{
    BOOL stringLength = ([self.subLabel.text length] > 0);
    if (!stringLength) {
        return NO;
    }
    
    BOOL labelTooLarge = ([self subLabelSize].width + self.leadingBuffer > self.bounds.size.width);
    return labelTooLarge;
}

@end
