//
//  NSString+StringContains.h
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/23/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//
//  http://stackoverflow.com/questions/3293499/detecting-if-an-nsstring-contains

#import <Foundation/Foundation.h>

@interface NSString (StringContains)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions) options;

@end