//
//  FLGSettingsViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 29/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGSettingsViewController.h"
#import "FLGUserDefaultsUtils.h"

@interface FLGSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *backgroundLocationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *closedAppLocationSwitch;

@end

@implementation FLGSettingsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"Settings";
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancelButtonDidPress:)];
    self.navigationItem.rightBarButtonItem = cancelBarButtonItem;
    
    self.backgroundLocationSwitch.on = [FLGUserDefaultsUtils pushNotificationReceptionInBackground];
    self.closedAppLocationSwitch.on = [FLGUserDefaultsUtils pushNotificationReceptionWhenAppIsClosed];
}

#pragma mark - Actions
- (IBAction)backgroudLocationSwitchValueChanged:(id)sender {
}

- (IBAction)closedAppLocationSwitchValueChanged:(id)sender {
}

- (IBAction)saveSettingsDidPress:(id)sender {
    [FLGUserDefaultsUtils savePushNotificationReceptionInBackground:self.backgroundLocationSwitch.isOn];
    [FLGUserDefaultsUtils savePushNotificationReceptionWhenAppIsClosed:self.closedAppLocationSwitch.isOn];
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
