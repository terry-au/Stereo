//
//  NIFSlantedTextPlaceholderArtworkView.h
//  Stereo
//
//  Created by Terry Lewis on 7/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
//    NIFDirectionUndefined = -1,
    NIFDirectionBackward,
    NIFDirectionForward,
} NIFDirection;

@interface NIFSlantedTextPlaceholderArtworkView : UIImageView

/**
 *  The subtitle
 */
@property (nonatomic, copy) NSString *placeholderSubtitle;

/**
 *  The title
 */
@property (nonatomic, copy) NSString *placeholderTitle;

/**
 *  The width of the parent view and the max width.
 */
@property (nonatomic) CGFloat parentViewWidth, constrainedWidth;

/**
 *  Creates a view with a given frame and whether or now overlays should be shown.
 *
 *  @param frame            the size and location of the view
 *  @param showOverlayViews whether overlay (transition) views should be shown
 *
 *  @return the configured view.
 */
- (instancetype)initWithFrame:(CGRect)frame showOverlayViews:(BOOL)showOverlayViews;

/**
 *  Sets the image and animates the transition provided the direction.
 *
 *  @param image      image to be set
 *  @param direction  direction the next playing item is in the queue (forward = next item)
 *  @param animated   whether the transition should be animated
 *  @param completion the block to be called upon completion
 */
- (void)setImage:(UIImage *)image direction:(NIFDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

/**
 *  Sets the placeholder text for the artwork view.
 *
 *  @param placeholderTitle    title of the placeholder text
 *  @param placeholderSubtitle subtitle of the placeholder text
 *  @param direction  direction the next playing item is in the queue (forward = next item)
 *  @param animated   whether the transition should be animated
 *  @param completion the block to be called upon completion
 */
- (void)setPlaceholderTitle:(NSString *)placeholderTitle placeholderSubtitle:(NSString *)placeholderSubtitle direction:(NIFDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
