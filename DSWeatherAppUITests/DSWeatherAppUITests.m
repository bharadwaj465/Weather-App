//
//  DSWeatherAppUITests.m
//  DSWeatherAppUITests
//
//  Created by bharadwaj Vangara on 2/13/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import <XCTest/XCTest.h>


static  NSString  * const kCellWeatherReportIdentifier = @"WeatherReportCellIdentifier";
static  NSString  * const kCellLocationIdentifier = @"LocationCellIdentifier" ;
static  NSString  * const kCellWeatherReportHeaderIdentifier = @"WeatherReportHeaderCellIdentifier";

@interface DSWeatherAppUITests : XCTestCase
@property XCUIApplication *app ;
@end

@implementation DSWeatherAppUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
   
    self.app = [[XCUIApplication alloc] init] ;
    [self.app launch];
   
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSearchBarEntry {
    XCUIElement *pleaseEnterACityOrAddressSearchField = self.app.searchFields[@"Please enter a city or address"];
    [pleaseEnterACityOrAddressSearchField tap];
    [pleaseEnterACityOrAddressSearchField typeText:@"Fremont"];
    
    XCTAssert([((NSString *)pleaseEnterACityOrAddressSearchField.value) isEqualToString:@"Fremont"]);
}

-(void)testSearchBarDelete{
    
    XCUIElement *pleaseEnterACityOrAddressSearchField = self.app.searchFields[@"Please enter a city or address"];
    [pleaseEnterACityOrAddressSearchField tap]; //brings focus
    [pleaseEnterACityOrAddressSearchField typeText:@"fremont"];
    
    XCUIElement *deleteKey = self.app/*@START_MENU_TOKEN@*/.keyboards.keys[@"delete"]/*[[".keyboards.keys[@\"delete\"]",".keys[@\"delete\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/;
    [deleteKey tap];
    [deleteKey tap];
    XCTAssert([((NSString *)pleaseEnterACityOrAddressSearchField.value) isEqualToString:@"fremo"]);
}

-(void)testSearchBarSearchButton{
    XCUIElement *pleaseEnterACityOrAddressSearchField = self.app.searchFields[@"Please enter a city or address"];
    [pleaseEnterACityOrAddressSearchField tap];
    [pleaseEnterACityOrAddressSearchField typeText:@"fremont"];
    [self.app/*@START_MENU_TOKEN@*/.keyboards.buttons[@"Search"]/*[[".keyboards.buttons[@\"Search\"]",".buttons[@\"Search\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/ tap];
    
    XCUIElementQuery *tablesQuery = self.app.tables;
    XCUIElement *cell  = tablesQuery[@"LocationCellIdentifier"].cells.staticTexts[@"Fremont"];
    XCTAssertNotNil(cell  , @"Location Cell  is not loaded"); // Cell with appropriate Identifier is loaded.
}

-(void)testForLocationCells{
    
    XCUIElement *pleaseEnterACityOrAddressSearchField = self.app.searchFields[@"Please enter a city or address"];
    [pleaseEnterACityOrAddressSearchField tap];
    [pleaseEnterACityOrAddressSearchField typeText:@"fremont"];
    [self.app/*@START_MENU_TOKEN@*/.keyboards.buttons[@"Search"]/*[[".keyboards.buttons[@\"Search\"]",".buttons[@\"Search\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/ tap];
    
    XCUIElementQuery *tablesQuery = self.app.tables;
    XCTAssertTrue( tablesQuery[@"LocationCellIdentifier"].exists , @"cells loaded");

    XCUIElement *cell  = tablesQuery[@"LocationCellIdentifier"].cells.staticTexts[@"Fremont"];
    XCTAssertNotNil(cell  , @"Location Cell  is not loaded"); // Cell with appropriate Identifier is loaded.
}

-(void)testForForeCastCells {
    
    //find the search bar
    XCUIElement *pleaseEnterACityOrAddressSearchField = self.app.searchFields[@"Please enter a city or address"];
    [pleaseEnterACityOrAddressSearchField tap];
    [pleaseEnterACityOrAddressSearchField typeText:@"Fremont"];
    //tap on search
    [self.app/*@START_MENU_TOKEN@*/.buttons[@"Search"]/*[[".keyboards.buttons[@\"Search\"]",".buttons[@\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    XCUIElementQuery *tablesQuery = self.app.tables;
    XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitUntiltimeOut"];
    
    //this will invoke tableView:didSelectRowatIndexpath:
    [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"   Fremont, CA, Alameda, United States"]/*[[".cells.staticTexts[@\"   Fremont, CA, Alameda, United States\"]",".staticTexts[@\"   Fremont, CA, Alameda, United States\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[exp] timeout:5];
    if(result){
        //just hold for five seconds untill service call is success.
    }
    
    //forecast cells count check.
    NSInteger countOfForeCastCells  = self.app.tables.element.cells.count ;
    XCTAssertEqual(countOfForeCastCells, 10, @"Cells are not fetched as expected");
    
    //Segmented Control on tap will reload Day's data to Night's forecast data.
    XCUIElement *nightButton = tablesQuery/*@START_MENU_TOKEN@*/.segmentedControls.buttons[@"Night"]/*[[".otherElements[@\"Fremont\"]",".segmentedControls.buttons[@\"Night\"]",".buttons[@\"Night\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[1]]@END_MENU_TOKEN@*/;
    [nightButton tap];
    
    //check if night's forecast data is loaded.
    XCUIElement *elementNight = self.app.tables.cells.staticTexts[@"Thursday Night"] ;
    BOOL exis = elementNight.exists ;
    XCTAssertTrue(exis , @"night cells does not exists");
    
    //Tap on segmented control to get back Day's data.
    XCUIElement *dayButton = tablesQuery.segmentedControls.buttons[@"Day"] ;
    [dayButton tap];

    XCUIElement *dayElement = self.app.tables.cells.staticTexts[@"Thursday"] ;
    BOOL isDayElement = dayElement.exists ;
    XCTAssertTrue(isDayElement , @"Day cells does not exists");

}

@end
