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
    return [[NSKeyedUnarchiver unarchiveObjectWithData:[def objectForKey:REGIONS_DATA_DEF_KEY]] mutableCopy];
}

@end
