//
//  WKObject.m
//  WeatherKit
//
//  Created by Ryan Nystrom on 9/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

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
