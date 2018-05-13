//
//  DSWeather.m
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/13/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import "DSWeatherLocation.h"

@implementation DSWeatherLocation
-(instancetype)initWithJSonDictionary:(NSDictionary *)jsonDictionary{
    
    self = [[DSWeatherLocation alloc] init];
    if(self){
        self.name = [jsonDictionary objectForKey:@"name"];
        self.city = [jsonDictionary objectForKey:@"type"];
        self.country = [jsonDictionary objectForKey:@"c"];
        self.latitude =  [((NSString *)[jsonDictionary objectForKey:@"lat"]) doubleValue];
        self.longitude =  [((NSString *)[jsonDictionary objectForKey:@"lon"]) doubleValue];
        self.urlString = [jsonDictionary objectForKey:@"l"];
        self.latitudeLongitude = [jsonDictionary objectForKey:@"ll"];
        
    }
    return self ;
}
@end
