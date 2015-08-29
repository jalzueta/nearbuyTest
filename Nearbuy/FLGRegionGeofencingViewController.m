//
//  FLGRegionGeofencingViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGRegionGeofencingViewController.h"
#import "Constants.h"
#import "NearbyClient.h"
#import "FLGUserDefaultsUtils.h"
#import "FLGRegion.h"
#import "FLGMapRegions.h"
#import "NSString+FLGStringUtils.h"
#import "FLGSettingsViewController.h"

@interface FLGRegionGeofencingViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) FLGMapRegions *mapRegions;

@end

@implementation FLGRegionGeofencingViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Geofencing when app opened
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        [self startReceivingLocation];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    //    [settingsButton setBackgroundImage:[UIImage imageNamed:@"btn_nav_info_on"] forState:UIControlStateHighlighted];
    [settingsButton addTarget:self
                       action:@selector(launchSettings:)
             forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsPoiBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: settingsButton];
    self.navigationItem.rightBarButtonItem = settingsPoiBarButtonItem;
    
    // Load Regions from NSUserDefaults or WS
    if (![FLGUserDefaultsUtils initialRegionsDownloaded]) {
        //TODO: download from WS
        self.mapRegions = [FLGMapRegions mapRegionsWithTrickValues];
        [FLGUserDefaultsUtils saveRegions:self.mapRegions.regions];
    }else{
        self.mapRegions = [FLGMapRegions mapRegionsWithRegions:[FLGUserDefaultsUtils regions]];
    }
    [self reloadRegionsObservation];
}

#pragma mark - Actions
- (void) launchSettings:(id) sender{
    FLGSettingsViewController *settingsViewcontroller = [[FLGSettingsViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingsViewcontroller];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

#pragma mark - Utils
- (void) startReceivingLocation{
    [self.locationManager startUpdatingLocation];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            [self showAlertControllerWithTitle:NSLocalizedString(@"ErrorTitle", nil)
                                       message:NSLocalizedString(@"kCLAuthorizationStatusRestrictedMessage", nil)
                                    buttonText:NSLocalizedString(@"Close", nil)];
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            [self showAlertControllerWithTitle:NSLocalizedString(@"ErrorTitle", nil)
                                       message:NSLocalizedString(@"kCLAuthorizationStatusDeniedMessage", nil)
                                    buttonText:NSLocalizedString(@"Close", nil)];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"kCLAuthorizationStatusAuthorizedAlways");
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            [self.locationManager startUpdatingLocation];
            break;
        default:
            break;
    }
}

- (void) showAlertControllerWithTitle: (NSString *) title
                              message: (NSString *) message
                           buttonText: (NSString *) buttonText{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:buttonText
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {}];
    
    [alertController addAction: closeAction];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void) sendUserEntranceInRegion: (FLGRegion *) region {
    // Check for user permissions
    BOOL sendNotificationRequest = YES;
    if (![UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        if ([FLGUserDefaultsUtils pushNotificationReceptionInBackground]) {
            sendNotificationRequest = NO;
        }
    }
    if (sendNotificationRequest) {
        NearbyClient *client = [[NearbyClient alloc] init];
        [client sendUserEntranceInRegion:region];
    }
}

- (void) reloadRegionsObservation{
//    NSLog(@"number of clRegions monitored: %lu", self.locationManager.monitoredRegions.count);
    for (CLRegion *clRegion in self.mapRegions.clRegions) {
        [self.locationManager startMonitoringForRegion:clRegion];
        [self.locationManager requestStateForRegion:clRegion];
    }
}

- (void) reloadData{
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
//    NSLog(@"Cambio de autorizacion: %d", status);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to get your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    [self showAlertControllerWithTitle:NSLocalizedString(@"ErrorTitle", nil)
                               message:NSLocalizedString(@"LocationManagerFailMessage", nil)
                            buttonText:NSLocalizedString(@"Ok", nil)];
}

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
//    NSLog(@"didStartMonitoringForRegion: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region {
    FLGRegion *flgRegion = [self.mapRegions regionWithIdentifier:[NSNumber numberWithInt:[region.identifier intValue]]];
    if (state == CLRegionStateInside) {
        if (flgRegion.shouldLaunchNotification) {
            [self sendUserEntranceInRegion:flgRegion];
            flgRegion.shouldLaunchNotification = NO;
        }
    }else{
        flgRegion.shouldLaunchNotification = YES;
    }
    [FLGUserDefaultsUtils saveRegions:self.mapRegions.regions];
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    if ([FLGUserDefaultsUtils pushNotificationToken]) {
        FLGRegion *flgRegion = [self.mapRegions regionWithIdentifier:[region.identifier flg_numberWithString]];
        flgRegion.shouldLaunchNotification = NO;
        [self sendUserEntranceInRegion:flgRegion];
    }
    [FLGUserDefaultsUtils saveRegions:self.mapRegions.regions];
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
    FLGRegion *flgRegion = [self.mapRegions regionWithIdentifier:[region.identifier flg_numberWithString]];
    flgRegion.shouldLaunchNotification = YES;
    [FLGUserDefaultsUtils saveRegions:self.mapRegions.regions];
}

// Before iOS 8
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self currentLocationUpdatedWithLocation:newLocation];
}

// After iOS 8
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self currentLocationUpdatedWithLocation:[locations lastObject]];
}

- (void) currentLocationUpdatedWithLocation: (CLLocation *) currentLocation{
    self.currentLocation = currentLocation;
}

@end
