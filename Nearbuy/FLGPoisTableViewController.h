//
//  FLGPoisTableViewController.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGLocationCoincidenceCheckerViewController.h"
#import "FLGRegionGeofencingViewController.h"
#import <MapKit/MapKit.h>
#import "FLGPoiDetailViewController.h"

@interface FLGPoisTableViewController : FLGRegionGeofencingViewController<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, PoiDetailViewControllerDelegate>

@end
