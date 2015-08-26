//
//  FLGPoisTableViewController.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGLocationCoincidenceCheckerViewController.h"
#import <MapKit/MapKit.h>

@interface FLGPoisTableViewController : FLGLocationCoincidenceCheckerViewController<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@end
