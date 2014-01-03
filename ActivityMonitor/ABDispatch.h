//
//  ABDispatch.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/2/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

// AB completion blocks
typedef void (^ABSetBlock)           (NSSet *set);
typedef void (^ABArrayBlock)         (NSArray *array);
typedef void (^ABDictionaryBlock)    (NSDictionary *dict);
typedef void (^ABBooleanBlock)       (BOOL yesOrNo);
typedef void (^ABIntegerBlock)       (NSInteger number);
typedef void (^ABBlock)              ();

@interface ABDispatch : NSObject

/**
 * Dispatches a block on the main thread
 */
void ABDispatchMain(ABBlock block);

/**
 * Dispatches a block on a background thread
 */
void ABDispatchBackground(ABBlock block);

/**
 * Dispatches a block on the main thread after a given number of seconds
 */
void ABDispatchAfter(float after, ABBlock block);

/**
 * Macro used for running a block only once.
 * Must use macro so the static token is dynamically compiled
 * WARNING: cannot use this twice in the same method
 */
#define AB_DISPATCH_ONCE(block)   \
if ((block)) {                    \
static dispatch_once_t _AB_token; \
dispatch_once(&_AB_token, block); \
}

@end
