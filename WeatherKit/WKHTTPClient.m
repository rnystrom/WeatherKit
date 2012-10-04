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