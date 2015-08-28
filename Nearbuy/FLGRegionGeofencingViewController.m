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
#import "Poi.h"
#import "PoisSet.h"
#import "UserDefaultsUtils.h"
#import "LastPoiCoincidence.h"

@interface FLGRegionGeofencingViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) PoisSet *poisSet;

@end

@implementation FLGRegionGeofencingViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//        self.locationManager.distanceFilter = 3;
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        [self startReceivingLocation];
    }
    self.poisSet = [PoisSet poiSetWithTrickValues];
    for (CLRegion *region in self.poisSet.regions) {
        [self.locationManager startMonitoringForRegion:region];
    }
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self startReceivingLocation];
//}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.locationManager stopUpdatingLocation];
//}

#pragma mark - Utils
- (void) startReceivingLocation{
    [self.locationManager startUpdatingLocation];
    
    UIAlertView *locationNotAllowed;
    
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
            locationNotAllowed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location not allowed title", nil) message:NSLocalizedString(@"kCLAuthorizationStatusRestricted message", nil) delegate:self cancelButtonTitle: NSLocalizedString(@"Location not allowed close button", nil) otherButtonTitles: nil];
            [locationNotAllowed show];
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            locationNotAllowed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location not allowed title", nil) message:NSLocalizedString(@"kCLAuthorizationStatusDenied message", nil) delegate:self cancelButtonTitle: NSLocalizedString(@"Location not allowed close button", nil) otherButtonTitles: nil];
            [locationNotAllowed show];
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

- (void) sendLocationCoincidenceWithPoi: (Poi *) coincidencePoi {
    NearbyClient *client = [[NearbyClient alloc] init];
    [client sendLocationCoincidenceForPoi:coincidencePoi];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"Cambio de autorizacion: %d", status);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    Poi *poiForRegion = [self.poisSet poiWithIdentifier:[UserDefaultsUtils lastPoiCoincidenceIdentifier]];
    if ([UserDefaultsUtils pushNotificationToken]) {
        [UserDefaultsUtils saveLastPoiCoincidenceIdentifier:[region.identifier integerValue]];
        poiForRegion.shouldLaunchPushNotification = NO;
        [LastPoiCoincidence sharedInstance].poi = poiForRegion;
        [self sendLocationCoincidenceWithPoi:[LastPoiCoincidence sharedInstance].poi];
    }
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
    
}
- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"didStartMonitoringForRegion: %@", region.identifier);
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
    [self checkLocationCoincidenceForLocation:self.currentLocation];
}
//
- (void) checkLocationCoincidenceForLocation: (CLLocation *) currentLocation{
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateBackground){
        NSLog(@"App is backgrounded. New location is %@", currentLocation);
    }
    Poi *poiInCurrentLocation = [self.poisSet poiInCurrentLocation:currentLocation];
    if (poiInCurrentLocation) {
        if (![poiInCurrentLocation isEqualToPoi: [LastPoiCoincidence sharedInstance].poi]) {
            NSLog(@"Poi detectado: %@", poiInCurrentLocation.name);
            NSLog(@"LastPoi: %@", [LastPoiCoincidence sharedInstance].poi.name);
            if ([UserDefaultsUtils pushNotificationToken]) {
                [UserDefaultsUtils saveLastPoiCoincidenceIdentifier:poiInCurrentLocation.identifier];
                [LastPoiCoincidence sharedInstance].poi = [self.poisSet poiWithIdentifier:[UserDefaultsUtils lastPoiCoincidenceIdentifier]];
                [self sendLocationCoincidenceWithPoi:[LastPoiCoincidence sharedInstance].poi];
            }
        }
    }
}

@end
