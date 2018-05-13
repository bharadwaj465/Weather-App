//
//  DSWeatherNetworkClient.m
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/14/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import "DSWeatherNetworkClient.h"
#import "DSWeatherForecastForTenDays.h"

static NSString const * forecastURl = @"http://api.wunderground.com/api/<API-Key>/forecast10day/q/" ;

@interface DSWeatherNetworkClient()

//private variables
@property(nonatomic,strong) NSURLSession *currentSession ;

@end


@implementation DSWeatherNetworkClient


+(DSWeatherNetworkClient *)sharedClient {
    static DSWeatherNetworkClient *sharedInstance = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
       sharedInstance.currentSession = [NSURLSession sharedSession];
    });
    return sharedInstance ;
}


#pragma mark - Auto Complete API.
//This method is not used. Written for Future Development.
-(void)getCityLocationWithString:(NSString *)searchString withSuccessBlock:(successBlock)success withFailureBlock:(failureBlock)failure  {
    
    //Prepare NSURL with NSURLComponents.
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"http";
    components.host = @"autocomplete.wunderground.com";
    components.path = @"/aq";
    NSURLQueryItem *query = [NSURLQueryItem queryItemWithName:@"query" value:searchString];
    components.queryItems = @[query] ;
    NSURL *url = components.URL;
    
    //By default the dataTaskWithURL uses GET requestType.
    NSURLSessionTask *dataTask = [self.currentSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            failure(error);
        }else{
            if(data){
                NSError *parseError = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&parseError];
                
                //check if the parsed data is correct.
                if(!parseError){
                    success(dictionary);
                }else{
                    failure(parseError);
                }
            }
        }
    }];
    [dataTask resume];
}


#pragma mark - ForeCast API.

-(void)getWeatherForCity:(NSString *)address withSuccessBlock:(successBlock)success withFailureBlock:(failureBlock)failure  {
    
    //Prepare url to fetch foreCast.
    NSString* urlString =  [NSString stringWithFormat:@"%@%@.json", forecastURl,address];
    
    NSURLSessionTask *dataTask = [self.currentSession dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    if(error){
        failure(error) ;
    }else{
        //check data is not nil  and success Reponse
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode ;
        if(data && statusCode == 200 ){
            NSError *parseError = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&parseError];
        
            //check if there is any parsing error.
            if(!parseError){
                
                //check if there any partial errors.
                NSDictionary * partialErrors = [dictionary valueForKeyPath:@"response.error"] ;
                if([partialErrors count]>0){
                    
                    NSError *partialCustomError = [self getErrorWithCode:statusCode withDomain:[partialErrors valueForKey:@"type"] withDescription:[partialErrors valueForKey:@"description"]] ;
                    failure(partialCustomError);
                    return ;
                }
                //if there no partial errors then pass On dictionary.
                NSDictionary* dictionaryForecast =  [dictionary valueForKeyPath:@"forecast"] ;
                success(dictionaryForecast);
            }else{
                failure(parseError);
            }
   
        }else{
            NSError *internalError  = [self getErrorWithCode:statusCode withDomain:nil withDescription:nil];
            failure(internalError);
        }
    }
        
    }];
    [dataTask resume];
}

-(NSError *)getErrorWithCode:(NSInteger)statusCode withDomain:(NSString *)domain withDescription:(NSString *)description{
    
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               };
    
    NSError *error = [[NSError alloc] initWithDomain:(domain.length>0)?domain:@"Internal Error" code:statusCode userInfo:userInfo];
    return error ;
}

@end
