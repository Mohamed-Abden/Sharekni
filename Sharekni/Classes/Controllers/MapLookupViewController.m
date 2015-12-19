//
//  MapLookupViewController.m
//  Sharekni
//
//  Created by Mohamed Abd El-latef on 10/18/15.
//
//

#import "MapLookupViewController.h"
#import <MapKit/MapKit.h>
#import "MobDriverManager.h"
#import <KVNProgress.h>
#import "MapLookUp.h"
#import <WYPopoverController.h>
#import "MapItemView.h"
#import "MapItemPopupViewController.h"
#import "MapInfoWindow.h"
#import "MobDriverManager.h"
#import "SearchResultsViewController.h"
#import "HelpManager.h"

@import GoogleMaps;
@interface MapLookupViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    GMSMapView *mapView_;
    BOOL currentLocationEnabled;
    GMSMarker *userMarker;
    
    
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) NSArray *mapLookups;
@property (nonatomic,strong) WYPopoverController *popover;
@property (nonatomic,strong) NSMutableArray *markers;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end

@implementation MapLookupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentLocationEnabled = NO;
    self.title = GET_STRING(@"Map Lookup");
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user-Location"] style:UIBarButtonItemStylePlain target:self action:@selector(currentLocationHanlder)];
    [self configureMapView];
    [self configureData];

}

- (void) currentLocationHanlder{
    currentLocationEnabled = !currentLocationEnabled;
    if (currentLocationEnabled) {
        [self.locationManager startUpdatingLocation];
    }
    else{
        userMarker.map = nil;
        [self.markers removeObject:userMarker];
        [self focusMapToShowAllMarkers];
    }
//    mapView_.myLocationEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
//    [mapView_ addObserver:self forKeyPath:@"myLocation" options:0 context:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [mapView_ removeObserver:self forKeyPath:@"myLocation"];
}

#pragma mark - KVO updates

/*- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if([keyPath isEqualToString:@"myLocation"]) {
        CLLocation *location = [object myLocation];
        //...
        NSLog(@"Location, %@,", location);
        
        CLLocationCoordinate2D target =
        CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        
        [mapView_ animateToLocation:target];
        [mapView_ animateToZoom:17];
    }
}
*/
- (void) configureMapView{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:24.4667
                                                            longitude:54.3667
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });

    mapView_.delegate = self;
}

- (void) configurePins{
    for (MapLookUp *mapLookUp in self.mapLookups) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(mapLookUp.FromLat.doubleValue, mapLookUp.FromLng.doubleValue);
        NSString *addressArabic = [NSString stringWithFormat:@"%@ - %@",mapLookUp.FromEmirateNameAr,mapLookUp.FromRegionNameAr];
        NSString *addressEnglish = [NSString stringWithFormat:@"%@ - %@",mapLookUp.FromEmirateNameEn,mapLookUp.FromRegionNameEn];
        GMSMarker *startMarker = [GMSMarker markerWithPosition:position];
        MapItemView *startItem = [[MapItemView alloc] initWithLat:mapLookUp.FromLng lng:mapLookUp.FromLng address:mapLookUp.FromRegionNameEn name:mapLookUp.FromEmirateNameEn];
        startItem.arabicName = addressArabic;
        startItem.englishName = addressEnglish;
        startItem.passengers = mapLookUp.NoOfPassengers.stringValue;
        startItem.drivers = mapLookUp.NoOfRoutes.stringValue;
        
        startItem.lookup = mapLookUp;
        
        startMarker.userData = startItem;
        startMarker.title = addressEnglish;
        startMarker.icon = [UIImage imageNamed:@"Location"];
        startMarker.map = mapView_;
        [self.markers addObject:startMarker];
    }
}

- (UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    MapItemView *mapItem = (MapItemView *)marker.userData;
    MapInfoWindow *infoWindow = [[MapInfoWindow alloc] initWithArabicName:mapItem.arabicName englishName:mapItem.englishName passengers:mapItem.passengers drivers:mapItem.drivers lat:mapItem.lat lng:mapItem.lng time:mapItem.comingRides];
    return infoWindow;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    [self showDetailsForMapItem:((MapItemView *)marker.userData)];
}

- (void) showDetailsForMapItem:(MapItemView *)mapitem{
    __block MapLookupViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    MapLookUp *lookup = mapitem.lookup;
    [[MobDriverManager sharedMobDriverManager] findRidesFromEmirateID:lookup.FromEmirateId.stringValue andFromRegionID:lookup.FromRegionId.stringValue toEmirateID:@"0" andToRegionID:@"0" PerfferedLanguageID:@"0" nationalityID:@"" ageRangeID:@"0" date:nil isPeriodic:nil saveSearch:nil WithSuccess:^(NSArray *searchResults) {
        
        [KVNProgress dismiss];
        if(searchResults){
            SearchResultsViewController *resultViewController = [[SearchResultsViewController alloc] initWithNibName:@"SearchResultsViewController" bundle:nil];
            resultViewController.results = searchResults;
            resultViewController.fromEmirate = lookup.FromEmirateNameEn;
            resultViewController.toEmirate = nil;
            resultViewController.fromRegion = lookup.FromRegionNameEn;
            resultViewController.toRegion = nil;
            [blockSelf.navigationController pushViewController:resultViewController animated:YES];
        }
        else{
            [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"No Rides Found")];
        }
    } Failure:^(NSString *error) {
        [KVNProgress dismiss];
    }];


}

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    CGPoint point = [mapView.projection pointForCoordinate:marker.position];
    point.y = point.y - 100;
    GMSCameraUpdate *camera =
    [GMSCameraUpdate setTarget:[mapView.projection coordinateForPoint:point]];
    [mapView animateWithCameraUpdate:camera];
    
    mapView.selectedMarker = marker;
    return YES;
}

- (void) focusMapToShowAllMarkers{
    CLLocationCoordinate2D myLocation = ((GMSMarker *)_markers.firstObject).position;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:myLocation];
    
    for (GMSMarker *marker in self.markers)
        bounds = [bounds includingCoordinate:marker.position];
    
    [mapView_ animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:100.0f]];
}

- (void) popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) configureData{
    [KVNProgress showWithStatus:@"Loading..."];
    __block MapLookupViewController *blockSelf = self;
    [[MobDriverManager sharedMobDriverManager] getMapLookupWithSuccess:^(NSArray *items) {
        [KVNProgress dismiss];
        blockSelf.mapLookups = items;
        blockSelf.markers = [NSMutableArray array];
        [blockSelf configurePins];
        [blockSelf focusMapToShowAllMarkers];
    } Failure:^(NSString *error) {
        [KVNProgress dismiss];
    }];
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //Configure Accuracy depending on your needs, default is kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    [self addUserLocation:location];
}

- (void) addUserLocation:(CLLocation *)location{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    userMarker = [GMSMarker markerWithPosition:position];
    userMarker.userData = nil;
    userMarker.title = @"Current Location";
    userMarker.icon = [UIImage imageNamed:@"CurrentLocation"];
    userMarker.map = mapView_;
    [self.markers addObject:userMarker];
    [self focusMapToShowAllMarkers];
}

@end
