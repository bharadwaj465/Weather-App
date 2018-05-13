//
//  DSWeatherLocationsViewModal.m
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/18/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import "DSWeatherLocationsViewModal.h"

@interface DSWeatherLocationsViewModal()
@property (nonatomic) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic)  NSString * nameOftheCity;
@end


@implementation DSWeatherLocationsViewModal
-(instancetype)initWithPlaceMark:(CLPlacemark *)placemark {
    self = [DSWeatherLocationsViewModal new];
    if(self){
        NSString *addString = @"" ;
        
        if(placemark.name){
            addString = [NSString stringWithFormat:@"%@,",placemark.name];
            self.nameOftheCity = placemark.name;
        }
       
        if(placemark.administrativeArea){
            addString = [NSString stringWithFormat:@" %@ %@,",addString,placemark.administrativeArea];
        }
        if(placemark.subAdministrativeArea){
            addString = [NSString stringWithFormat:@" %@ %@,",addString,placemark.subAdministrativeArea];
        }
        if(placemark.country){
            addString = [NSString stringWithFormat:@" %@ %@",addString,placemark.country];
        }
        self.locationInfo =  addString;
        self.nameOftheCity = placemark.name ?placemark.name : @"" ;
        self.locationCoordinate = placemark.location.coordinate ;
    }
    return self ;
}

-(NSString *)getCoordinates{
    
    CLLocationCoordinate2D coordinates = self.locationCoordinate;
    NSString *newAdressLocation = [NSString stringWithFormat:@"%f,%f",coordinates.latitude,coordinates.longitude];
    return newAdressLocation ;
}

-(NSString *)cityName {
    return self.nameOftheCity ;
}

@end
