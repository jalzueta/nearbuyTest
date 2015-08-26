//
//  FLGPushNotificationReceiverViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGPushNotificationReceiverViewController.h"
#import "Constants.h"

@interface FLGPushNotificationReceiverViewController ()

@end

@implementation FLGPushNotificationReceiverViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNotifications];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self tearDownNotifications];
}

#pragma mark - Notifications
- (void) setupNotifications{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatDidReceivePushNotification:)
                   name:PUSH_NOTIFICATION_RECEIVED
                 object:nil];
}

- (void) tearDownNotifications{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

// PUSH_NOTIFICATION_RECEIVED
- (void) notifyThatDidReceivePushNotification: (NSNotification *) aNotification{
    
    NSString *pushNotificationTitle = [aNotification.userInfo objectForKey:PUSH_NOTIFICATION_TITLE_KEY];
    NSString *pushNotificationBody = [aNotification.userInfo objectForKey:PUSH_NOTIFICATION_BODY_KEY];
//    NSString *pushNotificationType = [aNotification.userInfo objectForKey:PUSH_NOTIFICATION_TYPE_KEY];
//    NSNumber *pushNotificationId = [aNotification.userInfo objectForKey:PUSH_NOTIFICATION_ID_KEY];
    
    UIAlertController *pushNotificationReceivedController = [UIAlertController alertControllerWithTitle:pushNotificationTitle
                                                                                                message:pushNotificationBody
                                                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {}];
    
    [pushNotificationReceivedController addAction: okAction];
    
    [self presentViewController:pushNotificationReceivedController
                       animated:YES
                     completion:nil];
}

@end
