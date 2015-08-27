//
//  NSNumber+FLGNumberUtils.m
//  Nearbuy
//
//  Created by Javi Alzueta on 28/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "NSNumber+FLGNumberUtils.h"

@implementation NSNumber (FLGNumberUtils)

- (NSString *) flg_stringWithNumberOfFractionDigits: (NSUInteger) numberOfFractionDigits{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = numberOfFractionDigits;
    return [formatter stringFromNumber:self];
}

@end
