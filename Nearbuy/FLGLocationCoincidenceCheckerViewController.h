//
//  FLGLocationCoincidenceCheckerViewController.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGPushNotificationReceiverViewController.h"
@import CoreLocation;

@interface FLGLocationCoincidenceCheckerViewController : FLGPushNotificationReceiverViewController<CLLocationManagerDelegate>

- (void) sendLocationCoincidence;

@end
