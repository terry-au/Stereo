//
//  NSObject+NullInstance.m
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NSObject+NullInstance.h"

@implementation NSObject (NullInstance)


/**
 *  Basic method that returns an [NSNull null] disguised as the class it is called upon.
 *
 *  @return an NSNull, statically casted to whatever instancetype it was called on.
 */
+ (instancetype)nullInstance{
    return [NSNull null];
}

@end
