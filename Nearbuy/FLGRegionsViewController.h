//
//  FLGRegionsViewController.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGRegionGeofencingViewController.h"
#import <MapKit/MapKit.h>
#import "FLGRegionDetailViewController.h"

@interface FLGRegionsViewController : FLGRegionGeofencingViewController<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, RegionDetailViewControllerDelegate>

@end
