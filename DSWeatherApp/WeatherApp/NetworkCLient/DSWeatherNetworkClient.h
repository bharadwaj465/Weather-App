//
//  DSWeatherNetworkClient.h
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/14/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successBlock)(NSDictionary *);
typedef void (^failureBlock)(NSError *);


typedef NS_ENUM(NSInteger, RequestType ){
    RequestTypeGet = 0,
    RequestTypePost,
    RequestTypePut,
    RequestTypeDelete
};


@interface DSWeatherNetworkClient : NSObject
+(DSWeatherNetworkClient *)sharedClient;


/**
 This Method takes a string in the format of "latitude,logitude" and fetches the forecastedData for next 10 days.
 
 @param address searchString provide searchString in format (latitude,longitude)
 @param success success passes a (NSDictionary *) to the blocks.
 @param failure failure block is called passing the error code.
 */
-(void)getWeatherForCity:(NSString *)address withSuccessBlock:(successBlock)success withFailureBlock:(failureBlock)failure;




/**
 This method take a address string and fetches array of Locations. Typically used to do auto complete.
 
 @param searchString address a string that contains address such as city , state .
 @param success success block that passes NSDictionary .
 @param failure failure block that passes NSError.
 */
-(void)getCityLocationWithString:(NSString *)searchString withSuccessBlock:(successBlock)success withFailureBlock:(failureBlock)failure DEPRECATED_ATTRIBUTE ;


@end
