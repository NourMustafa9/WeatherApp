//
//  WeatherInfoDetailsViewController.h
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherInfoDetailsViewController : UIViewController
@property (nonatomic, strong) NSManagedObject *cityWeatherInfo;

@property (weak, nonatomic) IBOutlet UILabel *disclaimerLbl;
@property (weak, nonatomic) IBOutlet UIView *exitView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UIImageView *weathInfo;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIView *dataContainerView;
@property (weak, nonatomic) IBOutlet UILabel *weatherDEsc;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLbl;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;

//SomeClass* instance = [[SomeClass alloc]init];

@end

NS_ASSUME_NONNULL_END
