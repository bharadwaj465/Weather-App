//
//  DSWeatherReportHeaderTableViewCell.h
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/19/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSWeatherDayAngNightControlDelegate<NSObject>
@required
-(void)didPressDayAndNightControl:(UISegmentedControl *)control ;
@end

@interface DSWeatherReportHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dayAndDateControl;
@property (weak, nonatomic) id<DSWeatherDayAngNightControlDelegate> delegate;
@end
