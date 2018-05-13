//
//  DSWeatherForeCastDay.m
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/17/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import "DSWeatherForeCastDay.h"

@implementation DSWeatherForeCastDay

-(instancetype)initWithJsonDictionary:(NSDictionary *)dictionary {
    self = [[DSWeatherForeCastDay  alloc] init];
    if(self){
        self.condition = [dictionary objectForKey:@"icon"];
        self.iconURL = [NSURL URLWithString:[dictionary objectForKey:@"icon_url"]];
        self.forecastInFahrenheit = [dictionary objectForKey:@"fcttext"];
        self.forecastInCelsius = [dictionary objectForKey:@"fcttext_metric"];
        self.day = [dictionary objectForKey:@"title"];
    }
    return self ;
}

@end
