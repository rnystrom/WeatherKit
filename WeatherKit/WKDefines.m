//
//  WKDefines.m
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

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