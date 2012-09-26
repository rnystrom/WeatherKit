//
//  WKAddress.h
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WKAddress : NSObject

@property (copy) NSString *street;
@property (copy) NSString *city;
@property (copy) NSString *state;
@property (copy) NSString *country;
@property (assign, nonatomic) BOOL isLoaded;
@property (assign, nonatomic) BOOL isLoading;

- (void)loadAddressForLocation:(CLLocation*)location;

@end
