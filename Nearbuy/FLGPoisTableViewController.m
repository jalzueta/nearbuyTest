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
#import "FLGPoiDetailViewController.h"
#import "MyLocation.h"

static NSString *const reuseIdentifier = @"cell";
#define TABLE_SEGMENT 0
#define MAP_SEGMENT 1
#define NO_EDITING_VALUE -1

@interface FLGPoisTableViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *testPushNotificationsButtonItem;

@property(nonatomic) NSInteger editingRow;

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
    [self loadAnnotations];
    
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

#pragma mark - TableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.editingRow = indexPath.row;
    Poi* poi = [self.poisSet poiAtIndex:self.editingRow];
    FLGPoiDetailViewController *poiDetailViewController = [[FLGPoiDetailViewController alloc] initWithPoi:poi];
    poiDetailViewController.delegate = self;
    [self.navigationController pushViewController:poiDetailViewController
                                         animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
}

#pragma mark - Map
- (void)currentLocationUpdatedWithLocation:(CLLocation *)currentLocation{
    [super currentLocationUpdatedWithLocation:currentLocation];
    CLLocationDistance regionRadius = 300;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, regionRadius * 2, regionRadius * 2);
    [self.mapView setRegion:region
                   animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MyLocation class]]) {
        MyLocation *myLocation = (MyLocation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        if (annotationView == nil) {
            annotationView = myLocation.annotationView;
        }else{
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

#pragma mark - Utils
-(void) registerNib{
    UINib *nib = [UINib nibWithNibName:@"FLGPoiTableViewCell"
                                bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[FLGPoiTableViewCell cellId]];
}

- (void) loadAnnotations{
    NSMutableArray * annotationsToRemove = [self.mapView.annotations mutableCopy];
    [annotationsToRemove removeObject:self.mapView.userLocation];
    [self.mapView removeAnnotations:annotationsToRemove];
    [self.mapView addAnnotations:self.poisSet.annotations];
}

- (void) addNewPoi:(id) sender{
    self.editingRow = NO_EDITING_VALUE;
    FLGPoiDetailViewController *poiDetailViewController = [[FLGPoiDetailViewController alloc] initForNewPoi];
    poiDetailViewController.delegate = self;
    [self.navigationController pushViewController:poiDetailViewController
                                         animated:YES];
}

#pragma mark - PoiDetailViewControllerDelegate
- (void)poiDetailViewController:(FLGPoiDetailViewController *)poiDetailViewController didPressedSavePoi:(Poi *)poi{
    if (self.editingRow == NO_EDITING_VALUE) {
        [self.poisSet addPoi:poi];
    }
    else{
        [self.poisSet updatePoi:poi];
    }
    [self.tableView reloadData];
    [self loadAnnotations];
}

@end
