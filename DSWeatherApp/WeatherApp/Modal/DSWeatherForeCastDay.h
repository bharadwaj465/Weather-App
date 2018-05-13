//
//  DSWeatherForeCastDay.h
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/17/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSHumidity.h"

@interface DSWeatherForeCastDay : NSObject

@property (nonatomic,strong) NSString *condition;  //icon
@property (nonatomic,strong) NSString *forecastInFahrenheit ;
@property (nonatomic,strong) NSString *forecastInCelsius ;
@property (nonatomic,strong) NSString *day ;
@property (nonatomic,strong) NSURL *iconURL ; //icon_url ;
@property (nonatomic,strong) DSHumidity *humidity ;
@property (nonatomic,strong) NSDate *forcastedDate ;


-(instancetype)initWithJsonDictionary:(NSDictionary *)dictionary ;

@end

