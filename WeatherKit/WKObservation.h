/*
 * WeatherKit
 *
 * Created by Ryan Nystrom on 10/2/12.
 * Copyright (c) 2012 Ryan Nystrom. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

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
