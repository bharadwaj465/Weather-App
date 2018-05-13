//
//  DSHumidity.m
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/18/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import "DSHumidity.h"

@implementation DSHumidity

-(instancetype) initWithJsonDictionary:(NSDictionary *)jsonDict {
    self = [[DSHumidity alloc] init];
    if(self){
        self.max = [((NSString *)[jsonDict valueForKey:@"maxhumidity"]) intValue] ;
        self.min = [((NSString *)[jsonDict valueForKey:@"minhumidity"]) intValue] ;
        self.avg = [((NSString *)[jsonDict valueForKey:@"avehumidity"]) intValue] ;
     }
    return self ;
}

@end
