//
//  FLGSettingsViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 29/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGSettingsViewController.h"

@interface FLGSettingsViewController ()

@end

@implementation FLGSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"Settings";
    
    UIBarButtonItem *addPoiBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancelButtonDidPress:)];
    self.navigationItem.leftBarButtonItem = addPoiBarButtonItem;
}

#pragma mark - Actions
- (IBAction)saveSettingsDidPress:(id)sender {
    [self dismiss];
}

- (void)cancelButtonDidPress:(id)sender {
    [self dismiss];
}

#pragma mark - Actions
- (void) dismiss {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}



@end
