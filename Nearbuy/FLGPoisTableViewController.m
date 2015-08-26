//
//  FLGPoisTableViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGPoisTableViewController.h"
#import "NearbyClient.h"
@import CoreLocation;

@interface FLGPoisTableViewController ()

@end

@implementation FLGPoisTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction)sendLocationCoincidenceDidPress:(id)sender{
    NearbyClient *client = [[NearbyClient alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:0
                                                      longitude:0];
    [client sendLocationCoincidence:location];
}

@end
