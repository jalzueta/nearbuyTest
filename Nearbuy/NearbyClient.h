//
//  NearbyClient.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@interface NearbyClient : NSObject

- (void) sendLocationCoincidence: (CLLocation *) location;

@end
