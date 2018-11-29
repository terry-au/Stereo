//
//  StereoTests.m
//  StereoTests
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NIFImageArtistCell.h"
#import "AppDelegate.h"
#import "NIFStereoTabBarController.h"

@interface AppDelegate (Private)

- (NIFStereoTabBarController *)tabBarControllerWithArrangement:(BOOL)arrange;

@end

@interface NIFMusicManager (Private)

- (NSDictionary *)artistInformation;

@end

@interface StereoTests : XCTestCase

@end

@implementation StereoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testArtistInformationDeterminationPerformance {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        NSDictionary *artistInfo1 = [[NIFMusicManager sharedManager] artistInformation];
        NSDictionary *artistInfo2 = [[NIFMusicManager sharedManager] artistInformation];
        XCTAssertEqual(artistInfo1, artistInfo2);
    }];
}

/**
 * Tests for correct use of grammar and singularity/plurality.
 */
- (void)testArtistCellText{
    NIFImageArtistCell *cell = [[NIFImageArtistCell alloc] init];
    
    [cell setAlbumsCount:1 songsCount:1];
    XCTAssert([cell.detailTextLabel.text isEqualToString:@"1 album, 1 song"]);
    
    [cell setAlbumsCount:1 songsCount:2];
    XCTAssert([cell.detailTextLabel.text isEqualToString:@"1 album, 2 songs"]);
    
    [cell setAlbumsCount:2 songsCount:1];
    XCTAssert([cell.detailTextLabel.text isEqualToString:@"2 albums, 1 song"]);
    
    [cell setAlbumsCount:2 songsCount:2];
    XCTAssert([cell.detailTextLabel.text isEqualToString:@"2 albums, 2 songs"]);
    
//    this should never really happen, but its nice to know it works!
    [cell setAlbumsCount:0 songsCount:0];
    XCTAssert([cell.detailTextLabel.text isEqualToString:@"0 albums, 0 songs"]);
}

/**
 * ensure the view controllers exist in a defined order, by default.
 */
- (void)testViewControllers{
    AppDelegate *main = [[AppDelegate alloc] init];
    
//    its much easier to test this if we assume there is no arrangement...
    NIFStereoTabBarController *tabBarController = [main tabBarControllerWithArrangement:NO];
    
    XCTAssertNotNil(tabBarController);
    XCTAssertTrue([tabBarController.viewControllers[0].title isEqualToString:NIFLocStr(@"PLAYLISTS")]);
    XCTAssertTrue([tabBarController.viewControllers[1].title isEqualToString:NIFLocStr(@"ARTISTS")]);
    XCTAssertTrue([tabBarController.viewControllers[2].title isEqualToString:NIFLocStr(@"SONGS")]);
    XCTAssertTrue([tabBarController.viewControllers[3].title isEqualToString:NIFLocStr(@"ALBUMS")]);
    XCTAssertTrue([tabBarController.viewControllers[4].title isEqualToString:NIFLocStr(@"GENRES")]);
    XCTAssertTrue([tabBarController.viewControllers[5].title isEqualToString:NIFLocStr(@"COMPILATIONS")]);
    XCTAssertTrue([tabBarController.viewControllers[6].title isEqualToString:NIFLocStr(@"COMPOSERS")]);
}

/**
 * Tests to make sure that MPMediaItems with nil fields have placeholders.
 */
- (void)testMPMediaItemSafety{
    MPMediaItem *nullItm = [[MPMediaItem alloc] init];
//    it's actually not possible to /legally/ initialise an MPMediaItem.
//    Instead, we can allocate memory and create a base one, with no values.
//    Hopefully the added categories will prevent the fields from returning nil values.
    
    
    XCTAssertNotNil([nullItm titleSafety]);
    XCTAssertNotNil([nullItm artistSafety]);
    XCTAssertNotNil([nullItm albumArtistSafety]);
    XCTAssertNotNil([nullItm albumSafety]);
    XCTAssertNotNil([nullItm composerSafety]);
//    and their nil counterparts.
    XCTAssertNil([nullItm title]);
    XCTAssertNil([nullItm artist]);
    XCTAssertNil([nullItm albumArtist]);
    XCTAssertNil([nullItm albumTitle]);
    XCTAssertNil([nullItm composer]);
}

/**
 * Tests to ensure that the library and data pulled from it is cached.
 * Creating the data in the library is somewhat expensive, it should only be done sparingly.
 */
- (void)testLibraryCaching{
    NSArray *songsPointer = [[NIFMusicManager sharedManager] songs];
    XCTAssertEqual(songsPointer, [[NIFMusicManager sharedManager] songs]);
    [[NSNotificationCenter defaultCenter] postNotificationName:MPMediaLibraryDidChangeNotification object:nil];
    XCTAssertNotEqual(songsPointer, [[NIFMusicManager sharedManager] songs]);
}

- (void)testSeekDestruction{
    NIFMusicPlayerController *player = [[NIFMusicPlayerController alloc] init];
    [player registerForRemoteControlEvents];
    
//    start seeking backward
    [player beginSeekingBackward];
//    make sure we are seeking
    XCTAssertTrue([player isSeeking]);
    
//    stop seeking
    [player endSeeking];
//    make sure we are no longer seeking
    XCTAssertFalse([player isSeeking]);
    
//    start seeking forward
    [player beginSeekingForward];
//    ensure we are seeking
    XCTAssertTrue([player isSeeking]);
    
//    pause, this should stop the seeking
    [player pause];
//    ensure we have stopped seeking
    XCTAssertFalse([player isSeeking]);
}

@end
