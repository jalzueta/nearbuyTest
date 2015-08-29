//
//  FLGUserDefaultsUtils.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLGUserDefaultsUtils : NSObject

+ (void) saveInitialRegionsDownloaded: (BOOL) initialRegionsDownloaded;
+ (BOOL) initialRegionsDownloaded;

+ (void) savePushNotificationToken: (NSData *) pushNotificationToken;
+ (NSString *) pushNotificationToken;

+ (void) saveRegions: (NSArray *) regions;
+ (NSMutableArray *) regions;

+ (void) savePushNotificationReceptionInBackground: (BOOL) pushNotificationReceptionInBackground;
+ (BOOL) pushNotificationReceptionInBackground;

+ (void) savePushNotificationReceptionWhenAppIsClosed: (BOOL) pushNotificationReceptionWhenAppIsClosed;
+ (BOOL) pushNotificationReceptionWhenAppIsClosed;

@end
