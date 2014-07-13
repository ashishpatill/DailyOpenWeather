//
//  CustomCell.h
//  DailyWeather
//
//  Created by Ashish Pisey on 7/12/14.
//  Copyright (c) 2014 com.Ashish.dailyWeather. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *forecastLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayNumber;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@end
