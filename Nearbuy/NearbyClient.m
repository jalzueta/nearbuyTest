//
//  NearbyClient.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "NearbyClient.h"
#import <AFNetworking/AFNetworking.h>
#import "UserDefaultsUtils.h"
#import "Poi.h"

@interface NearbyClient ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

@end

@implementation NearbyClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]
                           initWithBaseURL:[NSURL URLWithString:@"http://www.fillingapps.com/apps/tests/nearbuy/api"]];
    }
    return self;
}

- (void) sendLocationCoincidenceForPoi: (Poi *) poi{
    NSDictionary *parameters = @{
                                 @"latitude" : poi.latitude,
                                 @"longitude" : poi.longitude,
                                 @"pushNotificationToken" : [UserDefaultsUtils pushNotificationToken],
                                 @"poiName" : poi.name
                                 };
    
    //[self GET:@"coincidence_get.php" parameters:parameters];
    [self POST:@"coincidence_post.php" parameters:parameters];
}

- (void)  GET:(NSString *) path
   parameters:(NSDictionary *) parameters{
    [self.requestManager GET:path
                  parameters:parameters
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSLog(@"GET pushNotificationId OK");
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"GET pushNotificationId ERROR: %@", error);
                     }];
}

- (void) POST:(NSString *) path
   parameters:(NSDictionary *) parameters{
    [self.requestManager POST:path
                   parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"POST pushNotificationId OK");
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"POST pushNotificationId ERROR: %@", error);
                      }];
}

@end