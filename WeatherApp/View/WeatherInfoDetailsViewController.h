//
//  WeatherInfoDetailsViewController.h
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//

#import <UIKit/UIKit.h>
#import <WeatherApp-Swift.h>
//#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherInfoDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLbl;
@property (weak, nonatomic) IBOutlet UIView *exitView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UIImageView *weathInfo;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIView *dataContainerView;
//SomeClass* instance = [[SomeClass alloc]init];

@end

NS_ASSUME_NONNULL_END
