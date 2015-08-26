//
//  FLGLocationCoincidenceCheckerViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGLocationCoincidenceCheckerViewController.h"
#import "Constants.h"
#import "NearbyClient.h"
#import "Poi.h"
#import "PoisSet.h"

@interface FLGLocationCoincidenceCheckerViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) PoisSet *poisSet;
@property (strong, nonatomic) Poi *lastDetectedPoi;

@end

@implementation FLGLocationCoincidenceCheckerViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    [self startReceivingLocation];
    
    Poi *poi1 = [Poi poiWithIdentifier:1
                                  name:@"Mercadona"
                              latitude:@(42.794589)
                             longitude:@(-1.613783)
                           minDistance:@50];
    
    Poi *poi2 = [Poi poiWithIdentifier:2
                                  name:@"Casa"
                              latitude:@(42.794820)
                             longitude:@(-1.616424)
                           minDistance:@50];
    
    Poi *poi3 = [Poi poiWithIdentifier:3
                                  name:@"La Hacienda"
                              latitude:@(42.796038)
                             longitude:@(-1.613448)
                           minDistance:@50];
    
    Poi *poi4 = [Poi poiWithIdentifier:4
                                  name:@"Navarra Padel"
                              latitude:@(42.795778)
                             longitude:@(-1.613732)
                           minDistance:@50];
    
    Poi *poi5 = [Poi poiWithIdentifier:5
                                  name:@"Conasa"
                              latitude:@(42.796912)
                             longitude:@(-1.613313)
                           minDistance:@50];
    
    Poi *poi6 = [Poi poiWithIdentifier:6
                                  name:@"Eroski"
                              latitude:@(42.798044)
                             longitude:@(-1.613447)
                           minDistance:@50];
    
    Poi *poi7 = [Poi poiWithIdentifier:7
                                  name:@"Irulegui"
                              latitude:@(42.792406)
                             longitude:@(-1.614967)
                           minDistance:@50];
    
    Poi *poi8 = [Poi poiWithIdentifier:8
                                  name:@"Farmacia Maria"
                              latitude:@(42.789182)
                             longitude:@(-1.616590)
                           minDistance:@50];
    
    Poi *poi9 = [Poi poiWithIdentifier:9
                                  name:@"Tienda Padel/Tenis"
                              latitude:@(42.788825)
                             longitude:@(-1.617003)
                           minDistance:@50];
    
    Poi *poi10 = [Poi poiWithIdentifier:10
                                   name:@"Ayuntamiento"
                               latitude:@(42.789294)
                              longitude:@(-1.617413)
                            minDistance:@50];
    
    NSMutableArray *arrayOfPois = [NSMutableArray arrayWithObjects:poi1,
                                   poi2,
                                   poi3,
                                   poi4,
                                   poi5,
                                   poi6,
                                   poi7,
                                   poi8,
                                   poi9,
                                   poi10,
                                   nil];
    
    self.poisSet = [PoisSet poiSetWithArrayOfPois:arrayOfPois];
}

#pragma mark - Utils

- (void) sendLocationCoincidence {
    NearbyClient *client = [[NearbyClient alloc] init];
    [client sendLocationCoincidenceForPoi:self.lastDetectedPoi];
}

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

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"Cambio de autorizacion: %d", status);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

// Before iOS 8
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    [self checkLocationCoincidenceForLocation:currentLocation];
}

// After iOS 8
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    [self checkLocationCoincidenceForLocation:currentLocation];
}

- (void) checkLocationCoincidenceForLocation: (CLLocation *) currentLocation{
    Poi *poiInCurrentLocation = [self.poisSet poiInCurrentLocation:currentLocation];
    if (poiInCurrentLocation != self.lastDetectedPoi) {
        NSLog(@"Poi detectado: %@", poiInCurrentLocation.name);
        self.lastDetectedPoi = poiInCurrentLocation;
        if (poiInCurrentLocation) {
            [self sendLocationCoincidence];
        }
    }
}

@end
