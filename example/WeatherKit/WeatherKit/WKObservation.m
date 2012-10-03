//
//  WKObservation.m
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "WKObservation.h"
#import "WKHTTPClient.h"
#import "AFNetworking.h"
#import "NSString+StringContains.h"

@implementation WKObservation

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        NSLocale *locale = [NSLocale currentLocale];
        _isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    }
    return self;
}

#pragma mark - Network

- (void)loadWeatherForLocation:(CLLocation*)location completion:(void (^)(NSError *))completion {
    NSNumber *latitude = [NSNumber numberWithFloat:location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithFloat:location.coordinate.longitude];
    NSDictionary *params = @{
        @"la": latitude,
        @"lo": longitude,
        @"ic": @1,
    };
    
    self.isLoaded = NO;
    
    WKHTTPClient *httpClient = [WKHTTPClient sharedClient];
    [httpClient getPath:kWKObservationURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *parsingError = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&parsingError];
            
            if (! parsingError) {
                [self setValuesForKeysWithJSONDictionary:json dateFormatter:nil];
                
                self.isLoaded = YES;
                self.loadedDate = [NSDate date];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kWKCurrentObservationSuccessNotification object:nil];
            }
            else {
                NSDictionary *userInfo = @{ kWKObservationErrorKey: parsingError };
                [[NSNotificationCenter defaultCenter] postNotificationName:kWKCurrentObservationErrorNotification object:nil userInfo:userInfo];
            }
            
            if (completion) {
                completion(parsingError);
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // flag as loaded because connection is complete
            // in case anything depends on KVO of this object
            self.isLoaded = YES;
            NSDictionary *userInfo = @{ kWKObservationErrorKey: error };
            [[NSNotificationCenter defaultCenter] postNotificationName:kWKCurrentObservationErrorNotification object:nil userInfo:userInfo];
            
            if (completion) {
                completion(error);
            }
        });
    }];
}


#pragma mark - Getters

- (WeatherCondition)condition {
    // hard casting for testing
//    return kWeatherConditionThunderstorm;
    
    WeatherCondition returnValue = kWeatherConditionClear;
    if (self.desc) {
        NSString *lowerDesc = [self.desc lowercaseString];
        if ([lowerDesc containsString:@"rain"]) {
            returnValue = kWeatherConditionRain;
        }
        if ([lowerDesc containsString:@"haze"] ||
            [lowerDesc containsString:@"hazy"]) {
            returnValue = kWeatherConditionHaze;
        }
        if ([lowerDesc containsString:@"partly"] ||
            [lowerDesc containsString:@"cloud"]) {
            returnValue = kWeatherConditionPartlyCloudy;
        }
        if ([lowerDesc containsString:@"mostly"] &&
            ! [lowerDesc containsString:@"clear"]) {
            returnValue = kWeatherConditionMostlyCloudy;
        }
        if ([lowerDesc containsString:@"overcast"]) {
            returnValue = kWeatherConditionOvercast;
        }
        if ([lowerDesc containsString:@"fog"]) {
            returnValue = kWeatherConditionFog;
        }
        if ([lowerDesc containsString:@"thunderstorm"]) {
            returnValue = kWeatherConditionThunderstorm;
        }
        if ([lowerDesc containsString:@"snow"] ||
            [lowerDesc containsString:@"flur"]) {
            returnValue = kWeatherConditionSnow;
        }
        if ([lowerDesc containsString:@"hail"] ||
            [lowerDesc containsString:@"sleet"]) {
            returnValue = kWeatherConditionHail;
        }
        if ([lowerDesc containsString:@"wind"]) {
            returnValue = kWeatherConditionWind;
        }
    }
    return returnValue;
}


- (NSDate*)sunrise {
    if (self.sunriseDateTime && self.dateTime) {
        NSDate *rawDate = [NSDate dateWithTimeIntervalSince1970:self.sunriseDateTime.floatValue / 1000.0f];
        return [NSDate dateWithTimeInterval:self.timeOffset.floatValue sinceDate:rawDate];
    }
    return nil;
}


- (NSDate*)sunset {
    if (self.sunsetDateTime && self.dateTime) {
        NSDate *rawDate = [NSDate dateWithTimeIntervalSince1970:self.sunsetDateTime.floatValue / 1000.0f];
        return [NSDate dateWithTimeInterval:self.timeOffset.floatValue sinceDate:rawDate];
    }
    return nil;
}


- (NSNumber*)localTemperature {
    return [self convertTemperatureToLocale:_temperature];
}


- (NSNumber*)localTemperatureHigh {
    return [self convertTemperatureToLocale:_temperatureHigh];
}


- (NSNumber*)localTemperatureLow {
    return [self convertTemperatureToLocale:_temperatureLow];
}


#pragma mark - Setters

- (void)setDateTime:(NSNumber *)dateTime {
    _dateTime = dateTime;
    NSDate *now = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(dateTime.floatValue / 1000.0f)];
    float interval = [now timeIntervalSinceDate:date];
    self.timeOffset = [NSNumber numberWithFloat:interval];
}


#pragma mark - Helpers

- (NSNumber*)convertTemperatureToLocale:(NSNumber*)tempInFahrenheit {
    if (self.isMetric) {
        return [self fahrenheitToCelsius:tempInFahrenheit];
    }
    return tempInFahrenheit;
}

- (NSNumber*)fahrenheitToCelsius:(NSNumber*)fahrenheit {
    float fahrenheitf = fahrenheit.floatValue;
    fahrenheitf -= 32.0f;
    fahrenheitf *= 5.0f / 9.0f;
    return [NSNumber numberWithFloat:fahrenheitf];
}


@end