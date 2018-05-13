//
//  DSWeatherReportViewController.m
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/17/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import "DSWeatherReportViewController.h"
#import "DSWeatherNetworkClient.h"
#import "DSWeatherForecastForTenDays.h"
#import "DSWeatherViewModal.h"
#import "DSWeatherLocation.h"
#import <CoreLocation/CoreLocation.h>
#import "DSWeatherLocationsViewModal.h"
#import "UIImageView+AFNetworking.h"
#import "DSWeatherReportTableViewCell.h"
#import "DSWeatherReportHeaderTableViewCell.h"

//Making cell identifiers as static const as it shouldnt be changed.
static  NSString  * const kCellWeatherReportIdentifier = @"WeatherReportCellIdentifier";
static  NSString  * const kCellLocationIdentifier = @"LocationCellIdentifier" ;
static  NSString  * const kCellWeatherReportHeaderIdentifier = @"WeatherReportHeaderCellIdentifier";

//Search state will help in knowing what state we are in.
typedef NS_ENUM(NSInteger , SeachState) {
    SearchStateInProgess, //this state is active when search is in progress
    SearchStateCompleted  //this state will show forecasted data.
};

//To Filter forecasts into Day and Night
typedef NS_ENUM(NSInteger , Time) {
    DayTime = 0,
    NightTime
};


@interface DSWeatherReportViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,DSWeatherDayAngNightControlDelegate>

//private Outlets
@property (weak, nonatomic) IBOutlet UISearchBar *citySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *forecastTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic,strong) NSMutableArray *viewModals ;
@property (nonatomic,strong) NSMutableArray *locations;
@property (nonatomic,assign) SeachState currentState ;
@property (nonatomic,strong) NSString* cityName ;
@property (nonatomic,assign) Time timeOfTheDay ;


@end

@implementation DSWeatherReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //all initializations will take place here.
    [self initializations];
    
    //prepare tableview for registering Nibs, set row dimessions.
    [self prepareViews];
}

-(void) initializations{
    self.viewModals = [[NSMutableArray alloc] init];
    self.locations = [[NSMutableArray alloc] init];
    self.cityName =  @"";
    self.timeOfTheDay = DayTime ;
}

-(void) prepareViews {
    
    [self stopActivityIndicator];
    //registering xib
    [self.forecastTableView registerNib:[UINib nibWithNibName:@"DSWeatherReportTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCellWeatherReportIdentifier];
    [self.forecastTableView registerNib:[UINib nibWithNibName:@"DSWeatherReportHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCellWeatherReportHeaderIdentifier];
    
    self.forecastTableView.rowHeight = UITableViewAutomaticDimension ;
    self.forecastTableView.estimatedRowHeight = 130;
    self.forecastTableView.tableFooterView = [UIView new]; //this will remove extra lines and make appearnce clean.
}

#pragma mark - Search Bar Delegates

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.currentState = SearchStateInProgess ;  //Let other methods know that search is in Progress.
    [self.viewModals removeAllObjects];         //clear all existing objects.
    [self.forecastTableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    
    //if no input is given , donot invoke core location, as it is rate limited.
    if([searchBar.text isEqualToString:@""])
        return ;
    
    //invoke CoreLocation to find out the placemark where we get latitude and logitude of the searched place.
    [self getLocationFromAdress:searchBar.text];
}

#pragma mark - CoreLocation APIS

-(void)getLocationFromAdress :(NSString *)address{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || ([placemarks count]<1) )  {
            [self displayAlertWithTitle:@"Location not found!" Message:@"Please search a different city"];
        } else {
            [self.viewModals removeAllObjects]; //clear all view modals as table view might have previous searched results or forecasted data.
            for(CLPlacemark *placemark in placemarks){
                DSWeatherLocationsViewModal *vm = [[DSWeatherLocationsViewModal alloc] initWithPlaceMark:placemark];
                self.cityName = [vm cityName];
                [self.viewModals addObject:vm];  // View Modals are added as there might be more than one placemark returned.
            }
            [self.forecastTableView reloadData];
        }
    }];
    
}

#pragma mark - API Search Actions

-(void)didUserSearchWeatherForNewLocation:(NSString *)latitudeandLongitude{
    
    __block DSWeatherForecastForTenDays *tenDayForeCast ;
    __weak typeof(self) weakSelf = self ;
    
    DSWeatherNetworkClient *networkClient = [DSWeatherNetworkClient sharedClient];
    [networkClient getWeatherForCity:latitudeandLongitude withSuccessBlock:^(NSDictionary *jsonDictionary){
        tenDayForeCast = [[DSWeatherForecastForTenDays alloc] initWithJsonDictionary:jsonDictionary];
        [weakSelf.viewModals  removeAllObjects];   //once forecasted data is avaialble, remove viewmodals which are currently showing. Load Forecast View Modals.
        
        /*The following code will seperate ForecastDays into Day's Forecast and Night's Forecast.
         This data can be seperated at modal Level, but handling it here is more efficient and reduces code complexity. */
        for(int i=0; i <[tenDayForeCast.tenDayForecast count] ; i=i+2){
            DSWeatherViewModal *viewModalForDay = [[DSWeatherViewModal alloc] initWithModal:tenDayForeCast.tenDayForecast[i]];
            DSWeatherViewModal *viewModalForNight = [[DSWeatherViewModal alloc] initWithModal:tenDayForeCast.tenDayForecast[i+1]];

            NSArray *dayAndNight = @[viewModalForDay,viewModalForNight];
            [weakSelf.viewModals addObject:dayAndNight];
        }
        
        //perform UI Actions.
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.forecastTableView reloadData];
            [weakSelf stopActivityIndicator];
        });
        
    }withFailureBlock:^(NSError *error){
        //if error, show a custom message ;
        [self displayAlertWithTitle:@"we'are sorry!" Message:@"Unable to get forecast data. Please search a new place."];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModals ? [self.viewModals count] : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell ;
    if(self.currentState == SearchStateInProgess)
        cell = [self loadLocationsCellForTableView:tableView atIndexPath:indexPath];
    else
        cell = [self loadForcastCellForTableView:tableView atIndexPath:indexPath];

    return cell;
}


-(UITableViewCell *)loadForcastCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    
    DSWeatherReportTableViewCell * newCell  = [tableView dequeueReusableCellWithIdentifier:kCellWeatherReportIdentifier];
    
    //this check is not necesary as of now. Incase any of the above functionalities are changed. App will crash if we index empty viewModal.
    DSWeatherViewModal *viewModal = ([self.viewModals count] > 0) ? [[self.viewModals objectAtIndex:indexPath.row] objectAtIndex:self.timeOfTheDay]: nil;
    
    if(viewModal){
        [newCell.day setText:viewModal.day];
        [newCell.date setText:viewModal.date];
        
        if(viewModal.forecastInFahrenheit == nil){
            [newCell.descriptionWeather setHidden:YES];
        }
        [newCell.descriptionWeather setText:viewModal.forecastInFahrenheit];  //this text is dynamic. Make sure we wordwrap
        
        /*Aynchronously download Images. Once we download images, cache it. AFNEtworking+UIImageView will give us this flexibility.
        If we need to implement this ourselves, we need to dispatch async download the image and cache it once it is downloaded.
        Also handle overheads when we have 1000's of images, change the priority of previous task(suspend /cancel/move to background queue) and download images on visible cells on Priority.
        AFNEtworking+UIImageView will give us this flexibility.
         */
        [newCell.iconImageView setContentMode:UIViewContentModeScaleAspectFit];
        [newCell.iconImageView setImageWithURL:viewModal.iconURL placeholderImage:[UIImage imageNamed:@"weather_dummy"]];
        
        [newCell.maxValue setText:viewModal.maxhumidity];
        [newCell.avgValue setText:viewModal.avghumidity];
        [newCell.minValue setText:viewModal.minhumidity];
    }
    [newCell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return newCell ;
}

-(UITableViewCell *)loadLocationsCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:kCellLocationIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:kCellLocationIdentifier] ;
    }
    
    DSWeatherLocationsViewModal *viewModal = ([self.viewModals count] >0) ? [self.viewModals objectAtIndex:indexPath.row] : nil;  //safety check for future.
    if(viewModal){
        cell.textLabel.text = viewModal.locationInfo ;
        [cell.textLabel sizeToFit] ;
        [cell.textLabel setNumberOfLines:0];
    }
    [cell setSelectionStyle:(UITableViewCellSelectionStyleBlue)];
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (self.currentState == SearchStateCompleted)? 60.0 : 0 ;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DSWeatherReportHeaderTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:kCellWeatherReportHeaderIdentifier];
    [cell.cityNameLabel setText:self.cityName];
    cell.delegate = self ;
    [cell.dayAndDateControl setSelectedSegmentIndex:self.timeOfTheDay];
    return (self.currentState == SearchStateCompleted)? cell : nil;
}


#pragma mark - Table view delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.currentState == SearchStateInProgess){
        DSWeatherLocationsViewModal * vm = [self.viewModals objectAtIndex:indexPath.row];
        [self.viewModals removeAllObjects];
        self.currentState = SearchStateCompleted ;
        [self showActivityIndicator];
        [self.citySearchBar endEditing:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH , 0), ^{
            [self didUserSearchWeatherForNewLocation:[vm getCoordinates]];
        });
    }
}

#pragma mark - Alert View Actions

-(void)displayAlertWithTitle:(NSString *)title Message:(NSString *)message {
        // show an alert if no results were found
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self.viewModals removeAllObjects];
                                   [self.forecastTableView reloadData];
                               }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - DSWeatherDayAngNightControlDelegate

-(void)didPressDayAndNightControl:(UISegmentedControl *)control{
   self.timeOfTheDay  = control.selectedSegmentIndex ;
    [self.forecastTableView reloadData];
}


#pragma mark - Loading Indicator

-(void)showActivityIndicator {
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}

-(void)stopActivityIndicator{
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator startAnimating];
}
@end
