//
//  FLGPoisTableViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

@import CoreData;

#import "FLGRegionsViewController.h"
#import "FLGRegionTableViewCell.h"
#import "FLGUserDefaultsUtils.h"
#import "FLGRegionDetailViewController.h"
#import "MyLocation.h"
#import "Constants.h"
#import "NearbyClient.h"
#import "FLGRegion.h"
#import "FLGMapRegions.h"

static NSString *const reuseIdentifier = @"cell";
#define TABLE_SEGMENT 0
#define MAP_SEGMENT 1
#define NO_EDITING_VALUE -1

@interface FLGRegionsViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *testPushNotificationsButtonItem;

@property(nonatomic) NSInteger editingRow;

@end

@implementation FLGRegionsViewController

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
    [self loadAnnotations];
    [self loadOverlays];
    
    UIBarButtonItem *addPoiBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                        target:self
                                                                                        action:@selector(addNewPoi:)];
    self.navigationItem.rightBarButtonItem = addPoiBarButtonItem;
    
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
    if ([FLGUserDefaultsUtils pushNotificationToken]) {
        [self sendUserEntranceInRegion:[FLGRegion regionWithIdentifier:0
                                                                  name:@"Test"
                                                              latitude:@0
                                                             longitude:@0
                                                                radius:@0]];
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
    return self.mapRegions.numberOfRegions;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FLGRegionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FLGRegionTableViewCell cellId]];
    
    [cell configureWithRegion: [self.mapRegions regionAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - TableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.editingRow = indexPath.row;
    FLGRegion* region = [self.mapRegions regionAtIndex:self.editingRow];
    FLGRegionDetailViewController *regionDetailViewController = [[FLGRegionDetailViewController alloc] initWithRegion:region];
    regionDetailViewController.delegate = self;
    [self.navigationController pushViewController:regionDetailViewController
                                         animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableViewIn commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.mapRegions removeRegionAtIndex: indexPath.row];
        [FLGUserDefaultsUtils saveRegions:self.mapRegions.regions];
        [self reloadData];
        self.tableView.editing = NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Map
- (void)currentLocationUpdatedWithLocation:(CLLocation *)currentLocation{
    [self centerMapInLocation: currentLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MyLocation class]]) {
        MyLocation *myLocation = (MyLocation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        if (annotationView == nil) {
            annotationView = myLocation.annotationView;
        }else{
            annotationView.annotation = annotation;
            for (UIView *view in annotationView.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    ((UILabel *)view).text = myLocation.region.identifierString;
                    break;
                }
            }
        }
        return annotationView;
    }
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc]initWithCircle:overlay];
    renderer.fillColor = MAP_OVERLAY_COLOR;
    return renderer;
}

#pragma mark - Utils
-(void) registerNib{
    UINib *nib = [UINib nibWithNibName:@"FLGRegionTableViewCell"
                                bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[FLGRegionTableViewCell cellId]];
}

- (void) reloadData{
    [self.tableView reloadData];
    [self loadAnnotations];
    [self loadOverlays];
}

- (void) loadAnnotations{
    NSMutableArray * annotationsToRemove = [self.mapView.annotations mutableCopy];
    [annotationsToRemove removeObject:self.mapView.userLocation];
    [self.mapView removeAnnotations:annotationsToRemove];
    [self.mapView addAnnotations:self.mapRegions.annotations];
}

- (void) loadOverlays{
    NSMutableArray * overlaysToRemove = [self.mapView.overlays mutableCopy];
    [self.mapView removeOverlays:overlaysToRemove];
    [self.mapView addOverlays:self.mapRegions.overlays];
}

- (void) addNewPoi:(id) sender{
    self.editingRow = NO_EDITING_VALUE;
    FLGRegionDetailViewController *regionDetailViewController = [[FLGRegionDetailViewController alloc] initForNewRegion];
    regionDetailViewController.delegate = self;
    [self.navigationController pushViewController:regionDetailViewController
                                         animated:YES];
}

- (void) centerMapInLocation:(CLLocation *)currentLocation{
    CLLocationDistance regionRadius = 300;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, regionRadius * 2, regionRadius * 2);
    [self.mapView setRegion:region
                   animated:YES];
}

#pragma mark - RegionDetailViewControllerDelegate
- (void)regionDetailViewController:(FLGRegionDetailViewController *) regionDetailViewController didPressedSaveRegion:(FLGRegion *)region{
    if (self.editingRow == NO_EDITING_VALUE) {
        [self.mapRegions addRegion:region];
    }
    else{
        [self.mapRegions updateRegion:region];
    }
    [FLGUserDefaultsUtils saveRegions:self.mapRegions.regions];
    [self reloadData];
    [self reloadRegionsObservation];
}

@end
