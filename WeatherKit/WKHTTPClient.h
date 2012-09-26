//
//  WKHTTPClient.h
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "AFHTTPClient.h"
#import "WKDefines.h"

@interface WKHTTPClient : AFHTTPClient

+ (WKHTTPClient*)sharedClient;

@end
