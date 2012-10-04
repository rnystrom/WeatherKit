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

#import "WeatherKit.h"

@implementation WeatherKit {
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
        if (self.currentAddress.isLoaded) {
            if (_completion) {
                _completion(error);
            }
        }
        else {
            [self.currentAddress addObserver:self forKeyPath:@"isLoaded" options:NSKeyValueObservingOptionNew context:NULL];
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
- (void)reloadWithCompletion:(void (^)(NSError*))completion {
    if (completion) {
        _completion = [completion copy];
    }
    
    [self getLocation];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.currentAddress &&
        [keyPath isEqualToString:@"isLoaded"] &&
        self.currentAddress.isLoaded &&
        _completion) {
        _completion(nil);
    }
}


@end
