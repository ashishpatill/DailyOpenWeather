//
//  ViewController.h
//  DailyWeather
//
//  Created by Ashish Pisey on 7/11/14.
//  Copyright (c) 2014 com.Ashish.dailyWeather. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDetailScreen.h"
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *cityNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *currentLocation;
- (IBAction)ChooseCurrentLocation:(UIButton *)sender;
- (IBAction)doneBtnAction:(UIButton *)sender;
@end
