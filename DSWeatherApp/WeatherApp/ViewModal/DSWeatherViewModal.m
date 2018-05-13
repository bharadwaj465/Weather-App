//
//  DSWeatherViewModal.m
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/13/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import "DSWeatherViewModal.h"
#import "DSWeatherForeCastDay.h"
@implementation DSWeatherViewModal

-(instancetype)initWithModal:(DSWeatherForeCastDay *)weatherDayForecast{
    self = [[DSWeatherViewModal alloc] init];
    if(self && weatherDayForecast){
        self.condition = weatherDayForecast.condition ;
        self.forecastInCelsius =weatherDayForecast.forecastInCelsius ;
        self.forecastInFahrenheit = weatherDayForecast.forecastInFahrenheit ;
        self.day = weatherDayForecast.day ;
        self.iconURL = weatherDayForecast.iconURL ;
        self.maxhumidity = [NSString stringWithFormat:@"%d",weatherDayForecast.humidity.max ];
        self.minhumidity = [NSString stringWithFormat:@"%d",weatherDayForecast.humidity.min ];
        self.avghumidity = [NSString stringWithFormat:@"%d",weatherDayForecast.humidity.avg ];
    
        NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM dd,yyyy"];
        NSString *stringFromDate = [formatter stringFromDate:weatherDayForecast.forcastedDate];
        self.date = stringFromDate ;
    }
    return self;
}


@end
