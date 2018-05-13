//
//  DSWeatherForecast.m
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/17/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import "DSWeatherForecastForTenDays.h"

@implementation DSWeatherForecastForTenDays

-(instancetype)initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    
    self = [[DSWeatherForecastForTenDays alloc] init];
    if(self){
        
        //[simpleforecast
        NSArray *simpleForcastday =  [jsonDictionary valueForKeyPath:@"simpleforecast.forecastday"] ;
        
       NSDictionary *dictionary = [jsonDictionary objectForKey:@"txt_forecast"] ;
        
        self.dateRequested = [DSWeatherForecastForTenDays getDateFromString:(NSString *)dictionary[@"date"] withDateFormat:@"K:mm a z"];
        
        NSArray *arrayWithForecastdays = [dictionary objectForKey:@"forecastday"];
        NSMutableArray *temArray = [NSMutableArray new];
        
        int index = 0 ;
        for(id forecastdays in arrayWithForecastdays){
            DSWeatherForeCastDay *day = [[DSWeatherForeCastDay alloc] initWithJsonDictionary:forecastdays];
            
            NSDictionary *simpleForeCast = simpleForcastday[index/2] ;
            DSHumidity *humidity  = [[DSHumidity alloc]  initWithJsonDictionary:simpleForeCast];
            day.humidity = humidity ;
            day.forcastedDate =  [DSWeatherForecastForTenDays getDateFromString:(NSString *)[simpleForeCast valueForKeyPath:@"date.pretty"] withDateFormat:@"K:mm a z 'on' MMMM dd, yyyy"];
           
            [temArray addObject:day];
            index++;
        }
        self.tenDayForecast = [temArray copy];
    }
    return  self ;
}

+(NSDate *)getDateFromString :(NSString *)dateString withDateFormat:(NSString *)dateFormat {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}



@end
