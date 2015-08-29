//
//  NearbyClient.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "NearbyClient.h"
#import <AFNetworking/AFNetworking.h>
#import "FLGUserDefaultsUtils.h"
#import "FLGRegion.h"

@interface NearbyClient ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager2;

@end

@implementation NearbyClient

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSURL *baseURL = [NSURL URLWithString:@"http://www.fillingapps.com/apps/tests/nearbuy/api"];
        NSURL *baseURL = [NSURL URLWithString:@"http://www.protectfive.com/javi"];
        NSURL *regionsBaseURL = [NSURL URLWithString:@"http://www.fillingapps.com/apps/tests/nearbuy/api"];
        
        _requestManager = [[AFHTTPRequestOperationManager alloc]
                           initWithBaseURL:baseURL];
        [_requestManager.requestSerializer setValue:@"text/html"
                                 forHTTPHeaderField:@"Accept"];
        
        _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _requestManager.responseSerializer.acceptableContentTypes = [_requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        
        _requestManager2 = [[AFHTTPRequestOperationManager alloc]
                           initWithBaseURL:regionsBaseURL];
    }
    return self;
}

#pragma mark - Requests
- (void) sendUserEntranceInRegion: (FLGRegion *) region{
    NSDictionary *parameters = @{
                                 @"latitude" : region.latitude,
                                 @"longitude" : region.longitude,
                                 @"pushNotificationToken" : [FLGUserDefaultsUtils pushNotificationToken],
                                 @"poiName" : region.name
                                 };
    
    [self GET:@"coincidence_get_dev.php" parameters:parameters];
//    [self POST:@"coincidence_post.php" parameters:parameters];
}

- (void) fetchRegionsWithSuccessBlock:(void (^)(id json))successBlock{
    [self GET:@"regions_json.php" parameters:nil withSuccessBlock:successBlock];
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

- (void) GET:(NSString *) path
  parameters:(NSDictionary *) parameters
withSuccessBlock:(void (^)(NSArray *json))successBlock{
    [self.requestManager2 GET:path
                   parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          successBlock(responseObject);
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
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
