//
//  WeatherInfoDetailsViewController.m
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//

#import "WeatherInfoDetailsViewController.h"
#import <CoreData/CoreData.h>
@interface WeatherInfoDetailsViewController ()


@end

@implementation WeatherInfoDetailsViewController
//NSManagedObject *cityInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self setUpWeatherInfo];
    // Do any additional setup after loading the view.
}

- (void)setUpViews
{
    _dataContainerView.layer.cornerRadius = 45;

    _dataContainerView.layer.shadowOffset = CGSizeMake(.0f,.0f);
    _dataContainerView.layer.borderWidth = 0;
    _dataContainerView.layer.shadowRadius = 1.0f;
    _dataContainerView.layer.shadowOpacity = .9f;
    _dataContainerView.layer.shadowColor = [UIColor colorWithRed:7.f/255.f green:5.f/255.f blue:48.f/255.f alpha:0.2f].CGColor;


    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.layer.bounds;

    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor,
                            (id)([UIColor colorWithRed:214.f/255.f green:211.f/255.f blue:222.f/255 alpha:1.000].CGColor),
                            nil];

    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];

    gradientLayer.cornerRadius = self.view.layer.cornerRadius;
    [self.view.layer addSublayer:gradientLayer];
    [  self.view bringSubviewToFront:_dataContainerView ];
    [  self.view bringSubviewToFront:_exitView ];
    [  self.view bringSubviewToFront:_backgroundImg ];
    [  self.view bringSubviewToFront:_cityName ];
    [  self.view bringSubviewToFront:_disclaimerLbl ];




}

- (void)setUpWeatherInfo{
    self.cityName.text = [_cityWeatherInfo valueForKey:@"name"];
    self.weatherDEsc.text = [_cityWeatherInfo valueForKey:@"weatherDescription"];
    NSString *humidity = [ _cityWeatherInfo valueForKey:@"humidity" ];
    NSString *per = @" %";
    NSString *humidityText = [NSString stringWithFormat:@"%@", humidity] ;
    self.humidityLbl.text = [humidityText stringByAppendingString:per];


    self.windSpeed.text = [NSString stringWithFormat:@"%@", [_cityWeatherInfo valueForKey:@"speed"]] ;

    double tempInK = 0.0;
    double tempInC = 0.0;
    double factor = 273.15;
    tempInK = [ [_cityWeatherInfo valueForKey:@"temp" ] doubleValue];
    tempInC = tempInK - factor;
    NSString *cel = @" °C";
    NSString *tempInCel = [NSString stringWithFormat:@"%.2f", tempInC] ;
    self.tempLabel.text =  [tempInCel stringByAppendingString:cel];


    NSString *disclaimerConst = @"Weather information for ";
    NSString *cityCountryNAme = [_cityWeatherInfo valueForKey:@"name"];
    NSString *cityName = [cityCountryNAme componentsSeparatedByString:@","].firstObject;
    NSString *requestTime = [_cityWeatherInfo valueForKey:@"requestTime"];
    NSString *str1 = [disclaimerConst stringByAppendingString:cityName];
    _disclaimerLbl.text =  [NSString stringWithFormat:@"%@ %@", str1, requestTime];



    NSString *iconUrl = [_cityWeatherInfo valueForKey:@"iconUrl"];
    printf("%s", [iconUrl UTF8String]);
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: iconUrl]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            printf("%s", [@"bvhbjbjbhj " UTF8String]);
            self.weathInfo.image = [UIImage imageWithData: data];
        });
//        [data aut];
    });

}

- (IBAction)dismissView:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
