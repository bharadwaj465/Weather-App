//
//  DSHumidity.h
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/18/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSHumidity : NSObject

@property (nonatomic,assign) int max;
@property (nonatomic,assign) int avg;
@property (nonatomic,assign) int min;

-(instancetype) initWithJsonDictionary:(NSDictionary *)jsonDict ;

@end
