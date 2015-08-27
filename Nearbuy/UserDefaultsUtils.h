//
//  UserDefaultsUtils.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsUtils : NSObject

+ (void) savePushNotificationToken: (NSData *) pushNotificationToken;
+ (NSString *) pushNotificationToken;

+ (void) saveLastPoiCoincidenceIdentifier: (NSUInteger) lastPoiCoincidenceIdentifier;
+ (NSUInteger) lastPoiCoincidenceIdentifier;

@end
