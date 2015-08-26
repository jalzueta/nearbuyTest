//
//  NearbyClient.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Poi;

@interface NearbyClient : NSObject

- (void) sendLocationCoincidenceForPoi: (Poi *) poi;

@end
