//
//  DSWeatherLocationsViewModal.h
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/18/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DSWeatherLocationsViewModal : NSObject
@property (nonatomic,copy) NSString *locationInfo ;

-(instancetype)initWithPlaceMark:(CLPlacemark *)placemark ;
-(NSString *)getCoordinates ;
-(NSString *)cityName;
@end
