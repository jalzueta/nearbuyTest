//
//  NearbyClient.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLGRegion;

@interface NearbyClient : NSObject

- (void) sendUserEntranceInRegion: (FLGRegion *) region;
- (void) fetchRegionsWithSuccessBlock:(void (^)(id json))successBlock;

@end
