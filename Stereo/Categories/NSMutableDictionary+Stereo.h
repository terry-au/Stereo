//
//  NSMutableDictionary+Stereo.h
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * http://stackoverflow.com/a/13279408
 */
@interface NSMutableDictionary (Stereo)
+ (NSMutableDictionary *)createDictionaryForSectionIndex:(NSArray *)array;
@end
