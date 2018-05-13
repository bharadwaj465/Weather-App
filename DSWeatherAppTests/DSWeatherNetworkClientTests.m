//
//  DSWeatherNetworkClientTests.m
//  DSWeatherAppTests
//
//  Created by bharadwaj Vangara on 2/17/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DSWeatherNetworkClient.h"
@interface DSWeatherNetworkClientTests : XCTestCase
@property  DSWeatherNetworkClient *networkClient ;
@end

@implementation DSWeatherNetworkClientTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.networkClient = [DSWeatherNetworkClient sharedClient];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//Positive Cases with Proper lattitude and Logitude.
- (void)testPositiveCaseGetWeather {
    
    XCTestExpectation *expectation  = [[XCTestExpectation alloc] initWithDescription:@"Download Data with address"];
    //fremont   Latitude‎: ‎37.548271   Longitude‎: ‎-121.988571
    
    [self.networkClient getWeatherForCity:@"37.548271,-121.988571" withSuccessBlock:^(NSDictionary *data) {
            XCTAssertNotNil(data,@"data Is empty");
            [expectation fulfill];
    } withFailureBlock:^(NSError * error) {
            XCTAssertNotNil(error,@"error is empty when serice failed");
            [expectation fulfill];
    }];
    
    XCTWaiter *waiter = [XCTWaiter new];
    [waiter waitForExpectations:@[expectation] timeout:(120)];
}

//Negative Case with Empty value
- (void)testGetWeatherWithEmptyValue {
    
    XCTestExpectation *expectation  = [[XCTestExpectation alloc] initWithDescription:@"Download Data with address"];
    //fremont   Latitude‎: ‎37.548271   Longitude‎: ‎-121.988571
    
    [self.networkClient getWeatherForCity:@"" withSuccessBlock:^(NSDictionary *data) {
            XCTAssertNil(data,@"data Is empty");
            [expectation fulfill];
    } withFailureBlock:^(NSError * error) {
        XCTAssertNotNil(error,@"error is empty when serice failed");
        [expectation fulfill];
    }];
    
    XCTWaiter *waiter = [XCTWaiter new];
    [waiter waitForExpectations:@[expectation] timeout:(120)];
    
}

//Negative Test Case With junk Values "asasdf"
- (void)testGetWeatherWithJunkData {
    
    XCTestExpectation *expectation  = [[XCTestExpectation alloc] initWithDescription:@"Download Data with address"];
    
    [self.networkClient getWeatherForCity:@"asasdf" withSuccessBlock:^(NSDictionary *data) {
        XCTAssertNil(data,@"data Is empty");
        [expectation fulfill];
    } withFailureBlock:^(NSError * error) {
        XCTAssertNotNil(error,@"error is empty when serice failed");
        [expectation fulfill];
    }];
    
    XCTWaiter *waiter = [XCTWaiter new];
    [waiter waitForExpectations:@[expectation] timeout:(2000)];
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
