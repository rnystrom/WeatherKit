WeatherKit
=========

WeatherKit is a simple and elegant solution to obtaining local weather information via the [WeatherBug API](http://weather.weatherbug.com/desktop-weather/api.html). WeatherKit is built as a static library. Installation is as simple as dragging and dropping into your project. Using this project is even easier.

## Installation

Drag WeatherKit.xcodeproj into your project as a **subproject** (do not add it as a workspace). Open your *Build Settings* and add WeatherKit as a **Target Dependency**. Add the following Frameworks under **Link Binary With Libraries**:

* AddressBook.framework
* CoreLocation.framework
* libWeatherKit.a

<img src="https://github.com/rnystrom/WeatherKit/blob/master/images/frameworks.png?raw=true" />

Under *Build Settings* search for "linker flag". Add "-ObjC" (no quotes) to **Other Linker Flags**.

<img src="https://github.com/rnystrom/WeatherKit/blob/master/images/linker.png?raw=true" />

Next search for "search path" and set **Always Search User Paths** to "Yes" (no quotes). Also change **Header Search Paths** to "${PROJECT_DIR}/WeatherKit" (quotes).

<img src="https://github.com/rnystrom/WeatherKit/blob/master/images/search.png?raw=true" />

I'd also recommend changing your scheme settings to build the library every time you run/build your project. I find myself tweaking my own, or other, libraries as I'm working on a project so everything is tailored to my needs. Click on your scheme and select *Edit Scheme*. Select the *Build* tab. Add WeatherKit to the targets. Uncheck *Parallelize Build* and drag WeatherKit above your project.

<img src="https://github.com/rnystrom/WeatherKit/blob/master/images/scheme.png?raw=true" />

## Usage

### WeatherBug API

Firstly, make sure you have an API key from WeatherBug. You can obtain one [here](http://weather.weatherbug.com/desktop-weather/api.html). Make sure you are using the XML REST key in your app.

### Getting the Weather

The <code>WeatherKit</code> object is the main object you will likely be using. When initialized it will attempt to find the user's location and load the latest weather. <code>WeatherKit</code> objects also find the user's address (not just latitude/longitude). You have access to:

``` objective-c
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) WKAddress *currentAddress;
@property (strong, nonatomic) WKObservation *currentObservation;

- (void)reloadWithCompletion:(void (^)(NSError*))completion;
```

### Conditions

I'm a little on the fence about how I do conditions. Based on th evast amounts of responses from WeatherBug, I've come up with some <code>typedefs</code> that take care of the problem. Conditions now default to <code>kWeatherConditionClear</code> if the response is unclear. Of course, this could lead to the possibility of a rare condition that results in the user seeing "Clear" when it *clearly* (ba-dum-tss) isn't.

``` objective-c
typedef enum {
    kWeatherConditionClear = 0,
    kWeatherConditionHaze = 1,
    kWeatherConditionPartlyCloudy = 2,
    kWeatherConditionMostlyCloudy = 3,
    kWeatherConditionOvercast = 4,
    kWeatherConditionFog = 5,
    kWeatherConditionThunderstorm = 6,
    kWeatherConditionSnow = 7,
    kWeatherConditionRain = 8,
    kWeatherConditionHail = 9,
    kWeatherConditionWind = 10,
} WeatherCondition;
```

These <code>typedefs</code> are also used for <code>NSString</code> representations (for labelling). See the following method for how the string is constructed.

``` objective-c
- (WeatherCondition)condition {
    WeatherCondition returnValue = kWeatherConditionClear;
    if (self.desc) {
        NSString *lowerDesc = [self.desc lowercaseString];
        // ...
    }
    return returnValue;
}
```

### Temperatures

There are 2 values for temperature, high temp, and low temp: raw and locale'd. The raw temperature is what is returned from WeatherBug which is always fahrenheit. The locale'd temperature checks the <code>NSLocale</code> of the user's device and returns the converted fahrenheit or celsius temperature.

### WKObservation

The property *currentObservation* on <code>WeatherKit</code> objects is of class <code>WKObservation</code>. If all you are dealing with is the user's current weather then you shouldn't ever have to deal with creating new <code>WKObservations</code>s. However, if you find yourself wanting to load observations for other <code>CLLocations</code> (you need the lat/lon to make a request).

## KVO & Notifications

Most of the classes included have properties to trigger KVO events:

``` objective-c
@property (assign, nonatomic) BOOL isLoaded;
@property (assign, nonatomic) BOOL isLoading; // not always included
```

There are also <code>NSNotifications</code> that are sent when locations, addresses, and observations are loaded.

``` objective-c
NSString * const kWKLocationUpdateSuccessNotification;
NSString * const kWKLocationUpdateErrorNotification;
NSString * const kWKAddressUpdateErrorNotification;
NSString * const kWKCurrentObservationSuccessNotification;
NSString * const kWKCurrentObservationErrorNotification;
```

If you are catching an error via <code>NSNotifications</code>, you can access the error in the userInfo dictionary with the following keys:

``` objective-c
NSString * const kWKLocationErrorKey;
NSString * const kWKObservationErrorKey;
```

## Vendors

Special shout out to [@mattt](https://github.com/mattt) for the wonderful [AFNetworking](https://github.com/AFNetworking/AFNetworking) that is included in this project.

## Contact

* [@nystrorm](https://twitter.com/nystrorm) on Twitter
* [@rnystrom](https://github.com/rnystrom) on Github
* <a href="mailTo:rnystrom@whoisryannystrom.com">rnystrom [at] whoisryannystrom [dot] com</a>

## License

Copyright (c) 2012 Ryan Nystrom (http://whoisryannystrom.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.