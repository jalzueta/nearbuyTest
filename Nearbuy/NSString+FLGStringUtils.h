//
//  NSString+FLGStringUtils.h
//  Nearbuy
//
//  Created by Javi Alzueta on 27/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FLGStringUtils)

- (BOOL)flg_isEqualIgnoreCaseToString:(NSString *)iString;
- (NSNumber *) flg_numberWithString;

@end
