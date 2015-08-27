//
//  LastPoiCoincidence.h
//  Nearbuy
//
//  Created by Javi Alzueta on 27/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Poi;

@interface LastPoiCoincidence : NSObject

@property(strong, nonatomic) Poi *poi;

+ (LastPoiCoincidence *) sharedInstance;

@end
