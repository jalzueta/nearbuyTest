//
//  UserDefaultsUtils.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "UserDefaultsUtils.h"
#import "Constants.h"

@implementation UserDefaultsUtils

+ (void) savePushNotificationToken: (NSData *) pushNotificationToken{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:pushNotificationToken forKey:PUSH_NOTIFICATION_TOKEN_DEF_KEY];
    [def synchronize];
}

+ (NSString *) pushNotificationToken {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *pushNotificationTokenData = [def objectForKey:PUSH_NOTIFICATION_TOKEN_DEF_KEY];
    NSString *pushNotificationTokenString = [[[[pushNotificationTokenData description]
                                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    return pushNotificationTokenString;
}

+ (void) saveLastPoiCoincidenceIdentifier: (NSUInteger) lastPoiCoincidenceIdentifier{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(lastPoiCoincidenceIdentifier) forKey:LAST_POI_COINCIDENCE_IDENTIFIER_DEF_KEY];
    [def synchronize];
}

+ (NSUInteger) lastPoiCoincidenceIdentifier {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *lastPoiCoincidenceIdentifier = [def objectForKey:LAST_POI_COINCIDENCE_IDENTIFIER_DEF_KEY];
    if (!lastPoiCoincidenceIdentifier) {
        [self saveLastPoiCoincidenceIdentifier:NO_LAST_POI_COINCIDENCE_IDENTIFIER_DEF_VALUE];
    }
    return (NSUInteger)[[def objectForKey:LAST_POI_COINCIDENCE_IDENTIFIER_DEF_KEY] integerValue];
}

@end
