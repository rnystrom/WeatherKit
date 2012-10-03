//
//  WKAddress.m
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "WKAddress.h"
#import "WKDefines.h"
#import <AddressBook/AddressBook.h>

@implementation WKAddress

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        _isLoaded = NO;
        _isLoading = NO;
    }
    return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSString*)description {
    return [NSString stringWithFormat:@"%@, %@, %@, %@",self.street,self.city,self.state,self.country];
}

#pragma mark - Networking

- (void)loadAddressForLocation:(CLLocation*)location {
    if (! self.isLoading) {
        self.isLoaded = NO;
        self.isLoading = YES;
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSDictionary *userInfo = @{ kWKLocationErrorKey: error};
                    [[NSNotificationCenter defaultCenter] postNotificationName:kWKLocationUpdateErrorNotification object:nil userInfo:userInfo];
                }
                else {
                    NSDictionary *address = [placemarks[0] addressDictionary];
                    self.street = address[(NSString *)kABPersonAddressStreetKey];
                    self.city = address[(NSString *)kABPersonAddressCityKey];
                    self.state = address[(NSString *)kABPersonAddressStateKey];
                    self.country = address[(NSString *)kABPersonAddressCountryKey];
                    self.isLoaded = YES;
                }
                self.isLoading = NO;
                self.isLoaded = YES;
            });
        }];
    }
}



@end