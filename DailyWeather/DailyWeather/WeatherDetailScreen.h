//
//  WeatherDetailScreen.h
//  DailyWeather
//
//  Created by Ashish Pisey on 7/12/14.
//  Copyright (c) 2014 com.Ashish.dailyWeather. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherDetailScreen : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet UITableView *weatherTableViw;
@property(nonatomic,retain)NSString *cityName;
@property(nonatomic,retain)NSString *type;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

- (IBAction)backBtnAction:(UIButton *)sender;

@end
