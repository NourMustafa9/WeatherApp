//
//  WeatherInfoDetailsViewController.m
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//
#import <WeatherApp-Swift.h>
#import "WeatherInfoDetailsViewController.h"

@interface WeatherInfoDetailsViewController ()


@end

@implementation WeatherInfoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];

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
    _disclaimerLbl.text =  @"Weather information for London received on 03.10.2019 - 11:28 ";



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
