//
//  DataModel.h
//  DailyWeather
//
//  Created by Ashish Pisey on 7/11/14.
//  Copyright (c) 2014 com.Ashish.dailyWeather. All rights reserved.
//

// This class handles all the data as well as parsing open weather json response

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property (nonatomic,retain)NSString *cloud;
@property (nonatomic,assign)NSString *humidity;
@property (nonatomic,retain)NSDictionary *temp;
@property (nonatomic,retain)NSDictionary *weather;
@property (nonatomic,retain)NSString *max;
@property (nonatomic,retain)NSString *min;
@property (nonatomic,retain)NSString *WeatherForcast;
@property (nonatomic,retain)NSString *imageName;
@property (nonatomic,retain)NSString *description;
@property (nonatomic,retain)NSDictionary *parentDictionary;
-(void)parseParentDictionary;

@end
