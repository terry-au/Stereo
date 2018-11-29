//
//  NIFAlbumViewController.h
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFMediaTableViewController.h"

@interface NIFAlbumViewController : NIFMediaTableViewController

- (instancetype)initWithFullAlbums:(BOOL)fullAlbums;

@property (nonatomic, strong) NSString *artistPersistentID;
@property (nonatomic) BOOL showingAlbumArtist;

@end
