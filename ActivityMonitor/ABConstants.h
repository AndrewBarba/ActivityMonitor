//
//  ABConstants.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/2/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#define AB_DOCUMENT_VERSION @"1.0"

#define AB_ICLOUD_ENABLED 0

//------------------------------------------ NSNOTIFICATIONS

#define ABMainDocumentOpenNotificationKey @"ABMainDocumentOpenNotification"
#define ABMainDocumentClosedNotificationKey @"ABMainDocumentClosedNotification"
#define ABiCloudDocumentUpdatedNotificationKey @"ABiCloudDocumentUpdatedNotification"

//------------------------------------------ MACROS

// Throws an exception if the current thread is not the main thread. This helps
// track down issues where UIKit calls are being made by helper threads.
#define AB_ASSERT_IS_MAIN_THREAD() if ([NSThread currentThread] != [NSThread mainThread]) @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@.%@ must be called on the main thread", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo:nil];

// Disables the init method on a class to force the use of a static initializer
#define AB_DISABLE_INIT() -(id)init{[super doesNotRecognizeSelector:_cmd];return nil;}

#define AB_DISABLE_UI() [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
#define AB_ENABLE_UI() [[UIApplication sharedApplication] endIgnoringInteractionEvents];
