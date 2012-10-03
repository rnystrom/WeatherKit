//
//  WeatherKit.h
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKDefines.h"
#import "WKObservation.h"
#import "WKAddress.h"
#import "WKHTTPClient.h"

typedef void (^weatherKitCompletion) (NSError*);

@interface WeatherKit : NSObject
<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) WKAddress *currentAddress;
@property (strong, nonatomic) WKObservation *currentObservation;
//@property (strong, nonatomic) WKObservation *previousObservation;

- (void)reloadWithCompletion:(weatherKitCompletion)completion;

@end
