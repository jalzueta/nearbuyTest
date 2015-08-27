//
//  Constants.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#pragma mark - Push NSUserDefaults
#define PUSH_NOTIFICATION_TOKEN_DEF_KEY @"pushNotificationToken"
#define LAST_POI_COINCIDENCE_IDENTIFIER_DEF_KEY @"lastPoiCoincidenceIdentifier"
#define NO_LAST_POI_COINCIDENCE_IDENTIFIER_DEF_VALUE -(1)

#pragma mark - Push Notifications
#define PUSH_NOTIFICATION_RECEIVED @"pushNotificationReceived"
#define PUSH_NOTIFICATION_TITLE_KEY @"pushNotificationTitle"
#define PUSH_NOTIFICATION_BODY_KEY @"pushNotificationBody"
#define PUSH_NOTIFICATION_TYPE_KEY @"pushNotificationType"
#define PUSH_NOTIFICATION_ID_KEY @"pushNotificationId"
#define PUSH_NOTIFICATION_CUSTOM_DATA_PARSE_KEY @"custom_data"
#define PUSH_NOTIFICATION_TYPE_PARSE_KEY @"type"
#define PUSH_NOTIFICATION_ID_PARSE_KEY @"id"

#pragma mark - Screen Size
#define SCREEN_BOUNDS   [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

#pragma mark - Fonts
#define MAP_ANNOTATIONS_IDENTIFIER_FONT [UIFont fontWithName:@"Raleway-light" size:13.0]

#pragma mark - Colors
#define RGBA(r,g,b,a)				[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)					RGBA(r, g, b, 1.0f)
#define HSBA(h,s,b,a)               [UIColor colorWithHue:h/360.0 saturation:s/100.0 brightness:b/100.0 alpha:a/1.0]
#define HSB(h,s,b)					HSBA(h, s, b, 1.0f)

#define KB_ACCESORY_VIEW_BUTTONS_TINT_COLOR     RGB(255,255,255)
#define DARK_ORANGE_COLOR     HSB(25,97,75)