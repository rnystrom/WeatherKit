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

#import "WKDefines.h"

#pragma mark - Notifications

NSString * const kWKLocationUpdateSuccessNotification       = @"com.whoisryannystrom.weatherkit.location-update";
NSString * const kWKLocationUpdateErrorNotification         = @"com.whoisryannystrom.weatherkit.location-update-error";
NSString * const kWKAddressUpdateErrorNotification          = @"com.whoisryannystrom.weatherkit.address-update-error";
NSString * const kWKCurrentObservationSuccessNotification   = @"com.whoisryannystrom.weatherkit.weather-update";
NSString * const kWKCurrentObservationErrorNotification     = @"com.whoisryannystrom.weatherkit.weather-update-error";


#pragma mark - Keys

NSString * const kWKLocationErrorKey = @"com.whoisryannystrom.weatherkit.location-update-error";
NSString * const kWKAddressErrorKey = @"com.whoisryannystrom.weatherkit.address-update-error";
NSString * const kWKObservationErrorKey = @"com.whoisryannystrom.weatherkit.address-update-error";


#pragma mark - API

NSString * const kWKBaseWeatherbugAPIURL = @"http://i.wxbug.net/REST/Direct/";
NSString * const kWKObservationURL = @"GetObs.ashx";


#pragma mark - Functions

float timef(NSDate *date) {
    if (date) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSInteger hour = components.hour;
        NSInteger minute = components.minute;
        
        float time = (float)hour + minute / 60.0f;
        return time;
    }
    return 0.0f;
}