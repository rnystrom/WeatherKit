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

#import "WKObject.h"
#import <objc/runtime.h>

@implementation WKObject

- (id)init {
    if (self = [super init]) {
        _isLoaded = NO;
    }
    return self;
}

- (void)setValuesForKeysWithJSONDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (int i=0; i<propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *keyName = [NSString stringWithUTF8String:propertyName];
        
        id value = [keyedValues objectForKey:keyName];
        if (value != nil && value != kCFNull) {
            char *typeEncoding = NULL;
            typeEncoding = property_copyAttributeValue(property, "T");
            
            if (typeEncoding == NULL) {
                continue;
            }
            switch (typeEncoding[0]) {
                case '@':
                {
                    // Object
                    Class class = nil;
                    if (strlen(typeEncoding) >= 3) {
                        char *className = strndup(typeEncoding+2, strlen(typeEncoding)-3);
                        class = NSClassFromString([NSString stringWithUTF8String:className]);
                    }
                    // Check for type mismatch, attempt to compensate
                    if ([class isSubclassOfClass:[NSString class]] && [value isKindOfClass:[NSNumber class]]) {
                        value = [value stringValue];
                    } else if ([class isSubclassOfClass:[NSNumber class]] && [value isKindOfClass:[NSString class]]) {
                        // If the ivar is an NSNumber we really can't tell if it's intended as an integer, float, etc.
                        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                        value = [numberFormatter numberFromString:value];
                    } else if ([class isSubclassOfClass:[NSDate class]] && [value isKindOfClass:[NSString class]] && (dateFormatter != nil)) {
                        value = [dateFormatter dateFromString:value];
                    }
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
            }
            [self setValue:value forKey:keyName];
            free(typeEncoding);
        }
    }
    free(properties);
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
