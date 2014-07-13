//
//  ViewController.m
//  DailyWeather
//
//  Created by Ashish Pisey on 7/11/14.
//  Copyright (c) 2014 com.Ashish.dailyWeather. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
{
    NSString *type;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

// http://api.openweathermap.org/data/2.5/forecast/daily?q=mumbai&cnt=14&units=metric&APPID=c3a2030a588d7d5edbc65748db8a4422


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ChooseCurrentLocation:(UIButton *)sender {
    type = @"By_location";
    [self performSegueWithIdentifier:@"GoToDetailsScreen" sender:self];
}

- (IBAction)doneBtnAction:(UIButton *)sender {
    type = @"By_name";
    
    // ensuring string is valid
    if ([self.cityNameTextField.text isEqualToString:@" "]||[self.cityNameTextField.text isEqualToString:@""])
    {
        UIAlertView *invalidNameAlert = [[UIAlertView alloc]initWithTitle:@"Invalid Name" message:@"Please enter valid city name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [invalidNameAlert show];
    }
    else
    {
        [self performSegueWithIdentifier:@"GoToDetailsScreen" sender:self];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.cityNameTextField resignFirstResponder];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToDetailsScreen"]) {
        WeatherDetailScreen *weatherVC =  (WeatherDetailScreen *)segue.destinationViewController;
        
        // checking if mode is by name or by location
        
        if ([type isEqualToString:@"By_name"]) {
            
            NSString *cityName = self.cityNameTextField.text;
            weatherVC.cityName = cityName;
            weatherVC.type = type;
        }
        else if([type isEqualToString:@"By_location"])
        {
            weatherVC.type = type;
        }
        
    }
}
@end
