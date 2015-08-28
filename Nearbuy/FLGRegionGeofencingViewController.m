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
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        [self startReceivingLocation];
    }
    self.poisSet = [PoisSet poiSetWithTrickValues];
    [self reloadRegionsObservation];
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

- (void) sendLocationCoincidenceWithPoi: (Poi *) coincidencePoi {
    NearbyClient *client = [[NearbyClient alloc] init];
    [client sendLocationCoincidenceForPoi:coincidencePoi];
}

- (void) reloadRegionsObservation{
    for (CLRegion *region in self.poisSet.regions) {
        [self.locationManager startMonitoringForRegion:region];
        [self.locationManager requestStateForRegion:region];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"Cambio de autorizacion: %d", status);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
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
//    NSLog(@"didDetermineState: %ld forRegion: %@", (long)state, region.identifier);
    if (state == CLRegionStateInside) {
        Poi *poiForRegion = [self.poisSet poiWithIdentifier:[region.identifier integerValue]];
        [self sendLocationCoincidenceWithPoi:poiForRegion];
        //TODO: set "shouldLaunchNotification: NO"
    }else{
        //TODO: set "shouldLaunchNotification: YES"
    }
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    Poi *poiForRegion = [self.poisSet poiWithIdentifier:[region.identifier integerValue]];
    if ([UserDefaultsUtils pushNotificationToken]) {
        poiForRegion.shouldLaunchPushNotification = NO;
        [self sendLocationCoincidenceWithPoi:poiForRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
    Poi *poiForRegion = [self.poisSet poiWithIdentifier:[region.identifier integerValue]];
    poiForRegion.shouldLaunchPushNotification = YES;
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
