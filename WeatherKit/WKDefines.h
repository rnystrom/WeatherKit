//
//  WKDefines.h
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>

// #define WEATHERBUG_API_KEY @"your_weatherbug_api_key"

#ifndef WEATHERBUG_API_KEY
#error "Must define WeatherBug API key"
#endif

typedef enum {
    kWeatherConditionClear = 0,
    kWeatherConditionHaze = 1,
    kWeatherConditionPartlyCloudy = 2,
    kWeatherConditionMostlyCloudy = 3,
    kWeatherConditionOvercast = 4,
    kWeatherConditionFog = 5,
    kWeatherConditionThunderstorm = 6,
    kWeatherConditionSnow = 7,
    kWeatherConditionRain = 8,
    kWeatherConditionHail = 9,
    kWeatherConditionWind = 10,
} WeatherCondition;

extern NSString * const kWKLocationUpdateSuccessNotification;
extern NSString * const kWKLocationUpdateErrorNotification;
extern NSString * const kWKAddressUpdateErrorNotification;
extern NSString * const kWKLocationErrorKey;
extern NSString * const kWKObservationErrorKey;
extern NSString * const kWKBaseWeatherbugAPIURL;
extern NSString * const kWKObservationURL;
extern NSString * const kWKCurrentObservationSuccessNotification;
extern NSString * const kWKCurrentObservationErrorNotification;

extern float timef(NSDate *date);
