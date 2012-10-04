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

#import <Foundation/Foundation.h>

//#define WEATHERBUG_API_KEY @"YOUR_KEY_GOES_HERE"

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
