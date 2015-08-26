//
//  FLGPoisTableViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGPoisTableViewController.h"
#import "PoisSet.h"
#import "Poi.h"
#import "FLGPoiTableViewCell.h"
#import "UserDefaultsUtils.h"

static NSString *const reuseIdentifier = @"cell";
#define TABLE_SEGMENT 0
#define MAP_SEGMENT 1

@interface FLGPoisTableViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *testPushNotificationsButtonItem;

@end

@implementation FLGPoisTableViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"Nearbuy Technical Test";
    [self registerNib];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.mapView.delegate = self;
    self.mapView.zoomEnabled = YES;
    self.mapView.showsUserLocation = YES;
    [self.mapView addAnnotations:self.poisSet.annotations];
    
    [self.testPushNotificationsButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor orangeColor], NSForegroundColorAttributeName,
                                                                  [UIFont fontWithName:@"Raleway-Medium" size:15.0], NSFontAttributeName, nil]
                                                        forState:UIControlStateNormal];
    
    [self.testPushNotificationsButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                                                  [UIFont fontWithName:@"Raleway-Medium" size:10.0], NSFontAttributeName, nil]
                                                        forState:UIControlStateHighlighted];
}


#pragma mark - Actions

- (IBAction)testPushNotificationsDidPress:(id)sender{
    if ([UserDefaultsUtils pushNotificationToken]) {
        [self sendLocationCoincidenceWithPoi:[Poi poiWithIdentifier:0
                                                               name:@"Test"
                                                           latitude:@0
                                                          longitude:@0
                                                        minDistance:@0]];
    }
}

- (IBAction)poisSegmentModeValueDidChange:(id)sender {
    UIView *originView;
    UIView *endView;
    UISegmentedControl *poiSegmentMode = (UISegmentedControl *)sender;
    if (poiSegmentMode.selectedSegmentIndex == TABLE_SEGMENT) {
        originView = self.mapView;
        endView = self.tableView;
    }else{
        originView = self.tableView;
        endView = self.mapView;
    }
    [UIView animateWithDuration:1
                     animations:^{
                         originView.alpha = 0;
                         endView.alpha = 1;
                     }];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.poisSet.poisCount;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FLGPoiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FLGPoiTableViewCell cellId]];
    
    [cell configureWithPoi: [self.poisSet poiAtIndex:indexPath.row]];
    
    return cell;
}

-(void) registerNib{
    
    UINib *nib = [UINib nibWithNibName:@"FLGPoiTableViewCell"
                         bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[FLGPoiTableViewCell cellId]];
}

#pragma mark - Map

- (void)currentLocationUpdatedWithLocation:(CLLocation *)currentLocation{
    CLLocationDistance regionRadius = 300;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, regionRadius * 2, regionRadius * 2);
    [self.mapView setRegion:region
                   animated:YES];
}

@end
