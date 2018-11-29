//
//  NSObject+NullInstance.h
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NullInstance)

/**
 *  Basic method that returns an [NSNull null] disguised as the class it is called upon.
 *
 *  Example [NSIndexPath nullInstance] instead of ((NSIndexPath )[NSNull null])
 *
 *  @return an NSNull, statically casted to whatever instancetype it was called on.
 */
+ (instancetype)nullInstance;

@end
