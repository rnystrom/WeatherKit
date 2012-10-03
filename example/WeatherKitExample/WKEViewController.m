//
//  WKEViewController.m
//  WeatherKitExample
//
//  Created by Ryan Nystrom on 10/3/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "WKEViewController.h"
#import <WeatherKit/WeatherKit.h>

@interface WKEViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiLabel;
@property (weak, nonatomic) IBOutlet UILabel *loLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) WeatherKit *weatherKit;

@end

@implementation WKEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.weatherKit = [[WeatherKit alloc] init];
    [self.weatherKit reloadWithCompletion:^(NSError *error) {
        if (error) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
        }
        else {
            [self.activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
            
            self.tempLabel.text = [NSString stringWithFormat:@"%.0f",[self.weatherKit.currentObservation localTemperature].floatValue];
            self.locationLabel.text = [NSString stringWithFormat:@"%@, %@",self.weatherKit.currentAddress.city,self.weatherKit.currentAddress.state];
            self.hiLabel.text = [NSString stringWithFormat:@"%.0f",[self.weatherKit.currentObservation localTemperatureHigh].floatValue];
            self.loLabel.text = [NSString stringWithFormat:@"%.0f",[self.weatherKit.currentObservation localTemperatureLow].floatValue];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
