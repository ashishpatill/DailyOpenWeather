//
//  WeatherDetailScreen.m
//  DailyWeather
//
//  Created by Ashish Pisey on 7/12/14.
//  Copyright (c) 2014 com.Ashish.dailyWeather. All rights reserved.
//

#import "WeatherDetailScreen.h"
#import "DataModel.h"
#import "Constants.h"
@interface WeatherDetailScreen ()
{
   NSArray *dayArray ;
   NSDate *previousDate;
   NSMutableArray *dateArray;
}
@end

@implementation WeatherDetailScreen
@synthesize cityName,type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self createDayArray];
    }
    return self;
}

// calculate next fourteen dates and convert them to string

-(void)createDayArray
{
    dateArray = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i<14; i++) {
        
        NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
        
        [myDateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        NSDateComponents *components= [[NSDateComponents alloc] init];
        
        [components setDay:1];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
        
        if (!previousDate) {
            
            previousDate = yesterday;
            
        }
        
        NSDate *dateIncremented= [calendar dateByAddingComponents:components toDate:previousDate options:0];
        
        previousDate = dateIncremented;
        
        NSString *NextDateString = [myDateFormatter stringFromDate:dateIncremented];

        [dateArray addObject:NextDateString];
        
    }
    
//    NSLog(@"date array %@",dateArray);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    dayArray = [[NSArray alloc]init];
    if ([type isEqualToString:@"By_name"]) {
        if (cityName) {
            [self parseData:cityName];
        }
        else
        {
            UIAlertView *invalidNameAlert = [[UIAlertView alloc]initWithTitle:@"Invalid Name" message:@"Please enter valid city name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [invalidNameAlert show];
        }
    }
    else if ([type isEqualToString:@"By_location"])
    {
        [self CurrentLocationIdentifier]; // call this method

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)parseData:(NSString *)city
{
    //------------------ URL Formatting start ---------------------------------//
    // remove spaces at end and beginning of string
    NSString* noSpaces =
    [[city componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
     componentsJoinedByString:@""];
    
    // replace places between words with '%20' (URL Formatting)
    noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    //------------------ URL Formatting end ---------------------------------//

    NSURL *weatherURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=14&units=metric&APPID=c3a2030a588d7d5edbc65748db8a4422",noSpaces]];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:weatherURL];
    
    if (!jsonData) {
        UIAlertView *noDataAlert = [[UIAlertView alloc]initWithTitle:@"Invalid Name" message:@"Please enter valid city name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noDataAlert show];
    }
    else
    {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        dayArray = [jsonDict objectForKey:@"list"];
        //    NSLog(@"day 1 data %@",[dayArray objectAtIndex:0]);
        
        //Assign city name
        self.cityLabel.text = [[jsonDict objectForKey:@"city"]objectForKey:@"name"];
        
        [self.weatherTableViw reloadData];

        // adjust table view height for various resolutions
        if (IS_IPHONE_4)
        {
            [self.weatherTableViw setContentSize:CGSizeMake(self.view.frame.size.width, 100 * 15)];
            
        }
        else
        {
            [self.weatherTableViw setContentSize:CGSizeMake(self.view.frame.size.width, 100 * 14)];
        }
        
        
        
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WeatherTableCell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    NSDictionary *dayDict = [dayArray objectAtIndex:indexPath.row];
    DataModel *dataObject = [[DataModel alloc]init];
    // Assign raw json data to data model
    dataObject.parentDictionary = dayDict;
    // parse and get data in dataObject (structured data)
    [dataObject parseParentDictionary];
    
    NSString *imageURLString = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",dataObject.imageName];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLString]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            cell.weatherImageView.image = [UIImage imageWithData:imageData];
            
        });
    });

    cell.humidityLabel.text = [NSString stringWithFormat:@"%@",dataObject.humidity];

    cell.forecastLabel.text = dataObject.description;
    cell.tempLabel.text = [NSString stringWithFormat:@"%@ C/%@ C",dataObject.max,dataObject.min];
    cell.dayNumber.text = [dateArray objectAtIndex:indexPath.row];
    
    return cell;
}

//------------ Current Location Address-----
-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    //------
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
            // NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
           //  NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             [self parseData:CountryArea];
             NSLog(@"%@",Area);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
