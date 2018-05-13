//
//  DSWeatherViewModal.h
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/13/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSWeatherForeCastDay.h"
#import  <UIKit/UIKit.h>

@interface DSWeatherViewModal : NSObject

@property (nonatomic,copy) NSString *condition;
@property (nonatomic,copy) NSString *forecastInFahrenheit ;
@property (nonatomic,copy) NSString *forecastInCelsius ;
@property (nonatomic,copy) NSString *day ;
@property (nonatomic,strong) NSURL * iconURL ;
@property (nonatomic,copy) NSString * date ;
@property (nonatomic,copy) NSString *maxhumidity;
@property (nonatomic,copy) NSString *minhumidity;
@property (nonatomic,copy) NSString *avghumidity;


-(instancetype)initWithModal:(DSWeatherForeCastDay *)weatherDayForecast ;

@end
