//
//  DSWeatherForecast.h
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/17/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSWeatherForecastForTenDays.h"
#import "DSWeatherForeCastDay.h"

@interface DSWeatherForecastForTenDays : NSObject

@property(nonatomic , strong) NSDate *dateRequested ;
@property(nonatomic, strong) NSArray <DSWeatherForeCastDay *>*tenDayForecast;

-(instancetype)initWithJsonDictionary:(NSDictionary *)dictionary ;

@end
