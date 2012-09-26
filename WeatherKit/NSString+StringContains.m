//
//  NSString+StringContains.m
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/23/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "NSString+StringContains.h"

@implementation NSString (StringContains)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end
