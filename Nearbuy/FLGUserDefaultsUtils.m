//
//  FLGUserDefaultsUtils.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGUserDefaultsUtils.h"
#import "Constants.h"

@implementation FLGUserDefaultsUtils

+ (void) saveInitialRegionsDownloaded: (BOOL) initialRegionsDownloaded{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(initialRegionsDownloaded) forKey:INITIAL_REGIONS_DOWNLOADED_DEF_KEY];
    [def synchronize];
}

+ (BOOL) initialRegionsDownloaded {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def dictionaryRepresentation].allKeys containsObject:INITIAL_REGIONS_DOWNLOADED_DEF_KEY]) {
        return [[def objectForKey:INITIAL_REGIONS_DOWNLOADED_DEF_KEY]boolValue];
    }else{
        return NO;
    }
}

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

+ (void) saveRegions: (NSArray *) regions{
    NSData *regionsData = [NSKeyedArchiver archivedDataWithRootObject:regions];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:regionsData forKey:REGIONS_DATA_DEF_KEY];
    [def synchronize];
    
    [self saveInitialRegionsDownloaded:YES];
}

+ (NSMutableArray *) regions{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def dictionaryRepresentation].allKeys containsObject:REGIONS_DATA_DEF_KEY]) {
        return [[NSKeyedUnarchiver unarchiveObjectWithData:[def objectForKey:REGIONS_DATA_DEF_KEY]] mutableCopy];
    }
    return nil;
}

+ (void) savePushNotificationReceptionInBackground: (BOOL) pushNotificationReceptionInBackground{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(pushNotificationReceptionInBackground) forKey:PUSH_NOTIFICATION_RECEPTION_IN_BACKGROUND_DEF_KEY];
    [def synchronize];
}

+ (BOOL) pushNotificationReceptionInBackground {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def dictionaryRepresentation].allKeys containsObject:PUSH_NOTIFICATION_RECEPTION_IN_BACKGROUND_DEF_KEY]) {
        return [[def objectForKey:PUSH_NOTIFICATION_RECEPTION_IN_BACKGROUND_DEF_KEY]boolValue];
    }else{
        return YES;
    }
}

+ (void) savePushNotificationReceptionWhenAppIsClosed: (BOOL) pushNotificationReceptionWhenAppIsClosed;{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(pushNotificationReceptionWhenAppIsClosed) forKey:PUSH_NOTIFICATION_RECEPTION_WHEN_APP_IS_CLOSED_DEF_KEY];
    [def synchronize];
}

+ (BOOL) pushNotificationReceptionWhenAppIsClosed {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def dictionaryRepresentation].allKeys containsObject:PUSH_NOTIFICATION_RECEPTION_WHEN_APP_IS_CLOSED_DEF_KEY]) {
        return [[def objectForKey:PUSH_NOTIFICATION_RECEPTION_WHEN_APP_IS_CLOSED_DEF_KEY]boolValue];
    }else{
        return YES;
    }
}

@end
