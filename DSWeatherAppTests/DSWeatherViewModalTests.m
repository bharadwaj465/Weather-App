//
//  DSWeatherViewModalTests.m
//  DSWeatherAppTests
//
//  Created by bharadwaj Vangara on 2/19/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSWeatherViewModal.h"
#import "DSWeatherLocationsViewModal.h"

@interface DSWeatherViewModalTests : XCTestCase
@property (nonatomic) DSWeatherViewModal * weatherViewModal ;

@end

@implementation DSWeatherViewModalTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//negative Test Case
- (void)testDSWeatherViewModal {
    
    self.weatherViewModal = [[DSWeatherViewModal alloc]  initWithModal:nil];
    XCTAssertNil(self.weatherViewModal.condition, @"test failed for condition");
    XCTAssertNil(self.weatherViewModal.forecastInFahrenheit, @"test failed for farenheit");
    XCTAssertNil(self.weatherViewModal.forecastInCelsius, @"celsium inforamton wrongly fetched");
    XCTAssertNil(self.weatherViewModal.day, @"day feild error");
    XCTAssertNil(self.weatherViewModal.iconURL, @"failed in icon URL");
    XCTAssertNil(self.weatherViewModal.date, @"failed in date");
    XCTAssertNil(self.weatherViewModal.maxhumidity, @"failed in maxhumidity");
    XCTAssertNil(self.weatherViewModal.minhumidity, @"min humidity");
    XCTAssertNil(self.weatherViewModal.avghumidity, @"avg humidity");

}

//negative Test Case
- (void)testDSWeatherViewModalWithIncompleteModal {
    
    DSWeatherForeCastDay *modal = [[DSWeatherForeCastDay alloc] init];
    modal.condition = @"clear";
    modal.forcastedDate =  [NSDate date];
    self.weatherViewModal = [[DSWeatherViewModal alloc]  initWithModal:modal];
    
    XCTAssert(self.weatherViewModal.condition.length > 0 , @"test failed for condition");
    
    XCTAssertNil(self.weatherViewModal.forecastInFahrenheit, @"test failed for farenheit");
    XCTAssertNil(self.weatherViewModal.forecastInCelsius, @"celsium inforamton wrongly fetched");
    XCTAssertNil(self.weatherViewModal.day, @"day feild error");
    XCTAssertNil(self.weatherViewModal.iconURL, @"failed in icon URL");
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMMM dd,yyyy"];
    NSString *dateString  = [dateFormatter stringFromDate:modal.forcastedDate];
    XCTAssert([self.weatherViewModal.date isEqualToString:dateString], @"failed in date");
}

-(void)testDSWeatherLocationsViewModal{
    DSWeatherLocationsViewModal *vm = [[DSWeatherLocationsViewModal alloc] initWithPlaceMark:nil];
   XCTAssertEqualObjects(vm.locationInfo , @"");
   XCTAssertEqualObjects([vm cityName] , @"");
   XCTAssertEqualObjects([vm getCoordinates] , @"0.000000,0.000000");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
