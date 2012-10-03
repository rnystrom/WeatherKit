//
//  WKHTTPClient.m
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "WKHTTPClient.h"

@implementation WKHTTPClient {
    dispatch_queue_t _callbackQueue;
}

#pragma mark - Singleton

+ (WKHTTPClient*)sharedClient {
	static WKHTTPClient *sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedClient = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:kWKBaseWeatherbugAPIURL]];
	});
	return sharedClient;
}


#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        _callbackQueue = dispatch_queue_create("com.nystromproductions.network-callback-queue", 0);
    }
    return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    if (! parameters) {
        parameters = [NSDictionary dictionary];
    }
    NSMutableDictionary *params = [parameters mutableCopy];
    [params addEntriesFromDictionary:@{ @"api_key" : WEATHERBUG_API_KEY }];
    [super getPath:path parameters:params success:success failure:failure];
}


- (NSMutableURLRequest*)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    // we never want to cache the response
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    return request;
}

@end