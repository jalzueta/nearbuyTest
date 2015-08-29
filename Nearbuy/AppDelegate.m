//
//  AppDelegate.m
//  Nearbuy
//
//  Created by Javi Alzueta on 25/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "FLGUserDefaultsUtils.h"
#import "FLGRegionsViewController.h"
#import "NearbyClient.h"
#import "FLGMapRegions.h"
#import "NSString+FLGStringUtils.h"
#import "FLGRegion.h"

@interface AppDelegate ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) FLGMapRegions *mapRegions;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Push notifications init
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // iOS 8
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS 7
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    [self resetPushNotificationsBadge];
    
    // Geofencing when app closed
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    if ([FLGUserDefaultsUtils regions]) {
        self.mapRegions = [FLGMapRegions mapRegionsWithRegions:[FLGUserDefaultsUtils regions]];
        for (CLRegion *clRegion in self.mapRegions.clRegions) {
            [self.locationManager startMonitoringForRegion:clRegion];
        }
    }
    
    // Build window
    FLGRegionsViewController *regionsViewController = [[FLGRegionsViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:regionsViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    
    [self setAppAppearance];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self resetPushNotificationsBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Appearance

- (void) setAppAppearance{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor orangeColor], NSForegroundColorAttributeName,
                                                          [UIFont fontWithName:@"Raleway-SemiBold" size:20.0], NSFontAttributeName, nil]];
}

#pragma mark - Push Notifications
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSLog(@"My token (1) is: %@", devToken);
    [FLGUserDefaultsUtils savePushNotificationToken:devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"application didReceiveRemoteNotification: %@", userInfo);
    NSString *pushNotificationTitle = [self getPushNotificationTitleFromUserInfoDictionary:userInfo];
    NSString *pushNotificationBody = [self getPushNotificationBodyFromUserInfoDictionary:userInfo];
    NSString *pushNotificationType = [self getPushNotificationTypeFromUserInfoDictionary:userInfo];
    NSNumber *pushNotificationId = [self getPushNotificationIdFromUserInfoDictionary:userInfo];
    
    NSNotification *n = [NSNotification notificationWithName:PUSH_NOTIFICATION_RECEIVED
                                                      object:self
                                                    userInfo:@{
                                                               PUSH_NOTIFICATION_TITLE_KEY: pushNotificationTitle,
                                                               PUSH_NOTIFICATION_BODY_KEY: pushNotificationBody,
                                                               PUSH_NOTIFICATION_TYPE_KEY: pushNotificationType,
                                                               PUSH_NOTIFICATION_ID_KEY: pushNotificationId
                                                               }];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (NSString *) getPushNotificationTitleFromUserInfoDictionary: (NSDictionary *) notificationDict{
    return [[[notificationDict objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"];
}

- (NSString *) getPushNotificationBodyFromUserInfoDictionary: (NSDictionary *) notificationDict{
    return [[[notificationDict objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
}

- (NSString *) getPushNotificationTypeFromUserInfoDictionary: (NSDictionary *) notificationDict{
    return [[notificationDict objectForKey:PUSH_NOTIFICATION_CUSTOM_DATA_PARSE_KEY] objectForKey:PUSH_NOTIFICATION_TYPE_PARSE_KEY];
}

- (NSNumber *) getPushNotificationIdFromUserInfoDictionary: (NSDictionary *) notificationDict{
    return [[notificationDict objectForKey:PUSH_NOTIFICATION_CUSTOM_DATA_PARSE_KEY] objectForKey:PUSH_NOTIFICATION_ID_PARSE_KEY];
}

- (void) resetPushNotificationsBadge{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    if ([FLGUserDefaultsUtils pushNotificationToken]) {
        FLGRegion *flgRegion = [self.mapRegions regionWithIdentifier:[region.identifier flg_numberWithString]];
        flgRegion.shouldLaunchNotification = NO;
        [self sendUserEntranceInRegion:flgRegion];
    }
    //TODO: [FLGUserDefaultsUtils saveRegions:self.mapRegions.regions];
}

- (void) sendUserEntranceInRegion: (FLGRegion *) region {
    NearbyClient *client = [[NearbyClient alloc] init];
    [client sendUserEntranceInRegion:region];
}

@end
