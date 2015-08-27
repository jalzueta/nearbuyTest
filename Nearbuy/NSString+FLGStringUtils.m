//
//  NSString+FLGStringUtils.m
//  Nearbuy
//
//  Created by Javi Alzueta on 27/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "NSString+FLGStringUtils.h"

@implementation NSString (FLGStringUtils)

- (BOOL)isEqualIgnoreCaseToString:(NSString *)iString {
    return ([self caseInsensitiveCompare:iString] == NSOrderedSame);
}

- (NSNumber *) numberWithString {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    return [f numberFromString:self];
}

@end
