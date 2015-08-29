//
//  FLGRegionGeofencingViewController.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGPushNotificationReceiverViewController.h"
@import CoreLocation;
@class FLGMapRegions;
@class FLGRegion;

@interface FLGRegionGeofencingViewController : FLGPushNotificationReceiverViewController<CLLocationManagerDelegate>

@property (strong, nonatomic, readonly) CLLocation *currentLocation;
@property (strong, nonatomic, readonly) FLGMapRegions *mapRegions;

- (void) sendUserEntranceInRegion: (FLGRegion *) region;
- (void) reloadRegionsObservation;

@end
