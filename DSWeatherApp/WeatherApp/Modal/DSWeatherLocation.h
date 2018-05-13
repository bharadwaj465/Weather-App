//
//  DSWeather.h
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/13/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSWeatherLocation : NSObject

@property (nonatomic ,copy) NSString *name ;
@property (nonatomic ,copy) NSString *city ;
@property (nonatomic ,copy) NSString *country ;
@property (nonatomic, assign) double latitude ;
@property (nonatomic,assign) double longitude ;
@property (nonatomic ,copy) NSString *urlString ; // this is taken as String as it needs to be appended later.
@property (nonatomic ) NSString *latitudeLongitude ;

-(instancetype)initWithJSonDictionary:(NSDictionary *)jsonDictionary;


@end
