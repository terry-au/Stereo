//
//  NIFBaseCell.m
//  Stereo
//
//  Created by Terry Lewis on 28/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFBaseCell.h"

@implementation NIFBaseCell

/**
 *  Override in subclass to setup views.
 */
- (void)setupViews{
//    implemented in subclass
}

/**
 *  Override in subclass to setup constraints.
 */
- (void)setupConstraints{
//    implemented in subclass
}

/**
 *  Sets up views and constraints.
 */
- (void)_setup{
    [self setupViews];
    [self setupConstraints];
}

/**
 *  Initialises the view and sets up subviews.
 *
 *  @param style           cell style.
 *  @param reuseIdentifier the reuse identifier
 *
 *  @return the configured cell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setup];
    }
    return self;
}

@end
