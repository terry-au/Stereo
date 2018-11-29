//
//  NIFBaseCell.h
//  Stereo
//
//  Created by Terry Lewis on 28/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIFBaseCell : UITableViewCell

/**
 *  Override in subclass to setup views.
 */
- (void)setupViews;

/**
 *  Override in subclass to setup constraints.
 */
- (void)setupConstraints;

@end
