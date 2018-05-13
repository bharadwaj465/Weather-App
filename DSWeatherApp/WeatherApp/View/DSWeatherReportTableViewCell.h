//
//  DSWeatherReportTableViewCell.h
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/18/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSWeatherReportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionWeather;
@property (weak, nonatomic) IBOutlet UILabel *minValue;
@property (weak, nonatomic) IBOutlet UILabel *avgValue;
@property (weak, nonatomic) IBOutlet UILabel *maxValue;

@end
