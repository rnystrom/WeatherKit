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