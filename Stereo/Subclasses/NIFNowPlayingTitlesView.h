//
//  NIFNowPlayingTitlesView.h
//  Stereo
//
//  Created by Terry Lewis on 5/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIFMarqueeLabel.h"

@interface NIFNowPlayingTitlesView : UIView <NIFMarqueeLabelDelegate>{
    
}

@property (nonatomic, strong) NIFMarqueeLabel *titleLabel, *artistLabel;
@property (nonatomic, strong) UILabel *auxilaryLabel;

//- (void)setArtistText:(NSString *)artistText;
//- (void)setTitleText:(NSString *)titleText;

/**
 *  Calls the appropriate method for the current device and caches the inputs.
 *
 *  @param titleText  song title
 *  @param albumText  album title
 *  @param artistText artist name
 */
- (void)setTitleText:(NSString *)titleText albumText:(NSString *)albumText artistText:(NSString *)artistText;

/**
 *  Should be called when super view controller didAppear is called.
 */
- (void)didAppear;
/**
 *  Should be called when super view controller willAppear is called.
 */
- (void)willAppear;
/**
 *  Should be called when super view controller willDisappear is called.
 */
- (void)willDisappear;

/**
 *  Sets the auxilary text, this does not scroll.
 *
 *  @param text   the text for the title field.
 *  @param detail the detail text.
 */
- (void)setAuxilaryText:(NSString *)text detail:(NSString *)detail;

/**
 *  Hides the auxilary text, such as scrubber details.
 */
- (void)hideAuxilaryText;

@end
