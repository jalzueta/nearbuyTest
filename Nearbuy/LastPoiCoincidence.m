//
//  LastPoiCoincidence.m
//  Nearbuy
//
//  Created by Javi Alzueta on 27/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "LastPoiCoincidence.h"

@implementation LastPoiCoincidence

+ (LastPoiCoincidence *) sharedInstance{
    static LastPoiCoincidence *inst = nil;
    @synchronized(self){
        if (!inst) {
            inst = [[self alloc] init];
        }
    }
    return inst;
}

@end
