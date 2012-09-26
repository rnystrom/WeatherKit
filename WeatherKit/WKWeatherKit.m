//
//  WeatherKit.m
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "WKWeatherKit.h"

@implementation WKWeatherKit {
    CLLocationManager *_locationManager;
    BOOL _firstLocationUpdate;
    BOOL _hasUpdateLocation;
    weatherKitCompletion _completion;
}

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        // none of these object inits do work, all work initiated by WKWeatherKit object
        // see reloadWithCompletion: or getLocation:
        _currentObservation = [[WKObservation alloc] init];
        _currentAddress = [[WKAddress alloc] init];
        _currentLocation = nil;
        
        // not calling reload because we are *not* reloading data
        // nothing has been collected
        [self getLocation];
    }
    return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - CLLocationManager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // avoiding caching
    if (! _firstLocationUpdate) {
        if (! _hasUpdateLocation) {
            _hasUpdateLocation = YES;
            self.currentLocation = locations[0];
        }
        
        [_locationManager stopUpdatingLocation];
    }
    else {
        _firstLocationUpdate = NO;
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = @{ kWKLocationErrorKey: error};
        [[NSNotificationCenter defaultCenter] postNotificationName:kWKLocationUpdateErrorNotification object:nil userInfo:userInfo];
        
        if (_completion) {
            _completion(error);
        }
    });
}

#pragma mark - Setters

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    _currentLocation = currentLocation;
    
    [self.currentAddress loadAddressForLocation:currentLocation];
    [self.currentObservation loadWeatherForLocation:currentLocation completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_completion) {
                _completion(error);
            }
        });
    }];
}


#pragma mark - Loading

- (void)getLocation {
    _hasUpdateLocation = NO;
    _firstLocationUpdate = YES;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}

// chain of callbacks:
// reloadWithCompletion     -> start updating location
// location updated         -> set current location
// current location set     -> load address, load weather for location
// weather loaded           -> fire completion block
- (void)reloadWithCompletion:(weatherKitCompletion)completion {
    if (completion) {
        _completion = [completion copy];
    }
    
    // save previous observation in case we want to do comparisons
//    self.previousObservation = [self.currentObservation copy];
    
    [self getLocation];
}


@end
