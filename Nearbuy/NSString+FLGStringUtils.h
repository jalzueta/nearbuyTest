//
//  NSString+FLGStringUtils.h
//  Nearbuy
//
//  Created by Javi Alzueta on 27/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FLGStringUtils)

- (BOOL)isEqualIgnoreCaseToString:(NSString *)iString;
- (NSNumber *) numberWithString;

@end
