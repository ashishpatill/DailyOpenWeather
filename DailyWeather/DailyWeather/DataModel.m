//
//  DataModel.m
//  DailyWeather
//
//  Created by Ashish Pisey on 7/11/14.
//  Copyright (c) 2014 com.Ashish.dailyWeather. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
@synthesize parentDictionary;
@synthesize cloud;
@synthesize weather;
@synthesize temp;
@synthesize max;
@synthesize min;
@synthesize imageName;
@synthesize description;
@synthesize WeatherForcast;
@synthesize humidity;

// Parses whole data for a day
-(void)parseParentDictionary
{
   self.cloud =  [self.parentDictionary objectForKey:@"clouds"];
   self.humidity = [self.parentDictionary objectForKey:@"humidity"];
   self.temp = [self.parentDictionary objectForKey:@"temp"];
    
    [self parseTemp];
    
   self.weather = [[self.parentDictionary objectForKey:@"weather"]objectAtIndex:0];
    
    [self parseWeather];
}

// parse temp dict
-(void)parseTemp
{
   self.max = [NSString stringWithFormat:@"%@",[self.temp objectForKey:@"max"]];
   self.min = [NSString stringWithFormat:@"%@",[self.temp objectForKey:@"min"]];
//   NSLog(@"max %@",max);
}

//parse weather dict
-(void)parseWeather
{
    
    self.description = [self.weather objectForKey:@"description"];
    self.WeatherForcast = [self.weather objectForKey:@"main"];
    self.imageName = [self.weather objectForKey:@"icon"];
}

@end
