//
//  WKObservation.h
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "WKObject.h"
#import "WKDefines.h"
#import <CoreLocation/CoreLocation.h>

@interface WKObservation : WKObject

@property (strong) NSNumber *avgWindDeg;
@property (copy) NSString *avgWindDirection;
@property (strong) NSNumber *avgWindSpeed;

@property (strong) NSNumber *dewpoint;

@property (strong) NSNumber *feelsLike;
@property (copy) NSString *feelsLikeLabel;

@property (strong) NSNumber *gustDeg;
@property (copy) NSString *gustDirection;
@property (strong) NSNumber *gustSpeed;

@property (strong) NSNumber *humidity;
@property (strong) NSNumber *humidityHigh;
@property (strong) NSNumber *humidityLow;
@property (strong) NSNumber *humidityRate;
@property (copy) NSString *humidityUnits;

@property (strong) NSNumber *moonPhase;

@property (strong) NSNumber *press;
@property (strong) NSNumber *pressHigh;
@property (strong) NSNumber *pressLow;
@property (strong) NSNumber *pressRate;

@property (strong) NSNumber *rainDaily;
@property (strong) NSNumber *rainMonthly;
@property (strong) NSNumber *rainRate;
@property (strong) NSNumber *rainYearly;

@property (copy) NSString *stationId;
@property (copy) NSString *stationName;

@property (strong, nonatomic) NSNumber *dateTime;
@property (strong) NSNumber *sunriseDateTime;
@property (strong) NSNumber *sunsetDateTime;

@property (strong) NSNumber *timeOffset;

// deals w/ metric vs imperial
// automatic conversion based on locale
@property (strong, nonatomic) NSNumber *temperature;
@property (strong, nonatomic) NSNumber *temperatureHigh;
@property (strong, nonatomic) NSNumber *temperatureLow;
@property (strong) NSNumber *temperatureRate;
@property (copy) NSString *temperatureUnits;

@property (strong) NSNumber *windDeg;
@property (copy) NSString *windDirection;
@property (strong) NSNumber *windSpeed;
@property (copy) NSString *windUnits;

@property (strong) NSDate *loadedDate;

@property (assign) BOOL isMetric;

// This is a description of the current conditions
// Method used to turn this into an enum that can be finite
@property (copy) NSString *desc;

- (void)loadWeatherForLocation:(CLLocation*)location completion:(void (^)(NSError *))completion;
- (WeatherCondition)condition;
- (NSDate*)sunrise;
- (NSDate*)sunset;
- (NSNumber*)localTemperature;
- (NSNumber*)localTemperatureHigh;
- (NSNumber*)localTemperatureLow;

@end
