//
//  DriverRideCell.m
//  sharekni
//
//  Created by Ahmed Askar on 11/4/15.
//
//

#import "DriverRideCell.h"
#import "UIView+Borders.h"
#import "Constants.h"
#import <UIColor+Additions/UIColor+Additions.h>

@implementation DriverRideCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DriverRideCell" owner:nil options:nil] objectAtIndex:(KIS_ARABIC)?1:0];
        
        [_RouteName addRightBorderWithColor:Red_UIColor];
        [_RouteName addLeftBorderWithColor:Red_UIColor];
        
        _containerView.layer.cornerRadius = 20;
        _containerView.layer.borderWidth = 1;
        _containerView.layer.borderColor = Red_UIColor.CGColor;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    [_RouteName addRightBorderWithColor:Red_UIColor];
    [_RouteName addLeftBorderWithColor:Red_UIColor];
    
    _containerView.layer.cornerRadius = 20;
    _containerView.layer.borderWidth = 1;
    _containerView.layer.borderColor = Red_UIColor.CGColor;
}

- (void)setDriverRideDetails:(DriverDetails *)driverRideDetails
{
    _driverRideDetails = driverRideDetails;
    
    if (KIS_ARABIC)
    {
        _FromRegionName.text = [NSString stringWithFormat:@"%@ - %@",_driverRideDetails.FromEmirateArName,_driverRideDetails.FromRegionArName];
        _ToRegionName.text = [NSString stringWithFormat:@"%@ - %@",_driverRideDetails.ToEmirateArName,_driverRideDetails.ToRegionArName];
        _RouteName.text = _driverRideDetails.RouteEnName ;
    }
    else
    {
        _RouteName.text = _driverRideDetails.RouteEnName ;
        _FromRegionName.text = [NSString stringWithFormat:@"%@ - %@",_driverRideDetails.FromEmirateEnName,_driverRideDetails.FromRegionEnName];
        _ToRegionName.text = [NSString stringWithFormat:@"%@ - %@",_driverRideDetails.ToEmirateEnName,_driverRideDetails.ToRegionEnName];
    }
}

- (void)setSavedResultRideDetails:(MostRideDetails *)rideDetails
{
    if (KIS_ARABIC)
    {
        _RouteName.text = [NSString stringWithFormat:@"%@ : %@",rideDetails.FromEmirateArName,rideDetails.ToEmirateArName] ;
        _FromRegionName.text = [NSString stringWithFormat:@"%@ - %@",rideDetails.FromEmirateArName,rideDetails.FromRegionArName];
        _ToRegionName.text = [NSString stringWithFormat:@"%@ - %@",rideDetails.ToEmirateArName,rideDetails.ToRegionArName];
        
        if (rideDetails.ToEmirateArName == nil) {
            _RouteName.text = [NSString stringWithFormat:@"%@",rideDetails.FromEmirateArName] ;
            _ToRegionName.text = @"";
        }
    }
    else
    {
        _RouteName.text = [NSString stringWithFormat:@"%@ : %@",rideDetails.FromEmirateEnName,rideDetails.ToEmirateEnName] ;
        _FromRegionName.text = [NSString stringWithFormat:@"%@ - %@",rideDetails.FromEmirateEnName,rideDetails.FromRegionEnName];
        _ToRegionName.text = [NSString stringWithFormat:@"%@ - %@",rideDetails.ToEmirateEnName,rideDetails.ToRegionEnName];
        
        if (rideDetails.ToEmirateEnName == nil) {
            _RouteName.text = [NSString stringWithFormat:@"%@",rideDetails.FromEmirateEnName] ;
            _ToRegionName.text = @"";
        }
    }
}

- (void)setJoinedRide:(Ride *)joinedRide
{
    _joinedRide = joinedRide;
    _RouteName.text = joinedRide.Name_en;
    
    if (KIS_ARABIC)
    {
        _FromRegionName.text = [NSString stringWithFormat:@"%@ - %@",joinedRide.FromEmirateArName,joinedRide.FromRegionArName];
        _ToRegionName.text = [NSString stringWithFormat:@"%@ - %@",joinedRide.ToEmirateArName,joinedRide.ToRegionArName];
    }
    else
    {
        _FromRegionName.text = [NSString stringWithFormat:@"%@ - %@",joinedRide.FromEmirateEnName,joinedRide.FromRegionEnName];
        _ToRegionName.text = [NSString stringWithFormat:@"%@ - %@",joinedRide.ToEmirateEnName,joinedRide.ToRegionEnName];
    }
    
    [self.firstButton setTitle:GET_STRING(@"Details") forState:UIControlStateNormal];
    [self.secondButton setTitle:GET_STRING(@"Driver") forState:UIControlStateNormal];
    [self.thirdButton setTitle:GET_STRING(@"Leave") forState:UIControlStateNormal];
}

- (void)setCreatedRide:(CreatedRide *)createdRide
{
    _createdRide = createdRide;
    
    _RouteName.text = createdRide.Name_en;
    
    if (KIS_ARABIC) {
        _FromRegionName.text = [NSString stringWithFormat:@"%@ - %@",createdRide.FromEmirateArName,createdRide.FromRegionArName];
        _ToRegionName.text = [NSString stringWithFormat:@"%@ - %@",createdRide.ToEmirateArName,createdRide.ToRegionArName];
    }
    else
    {
        _FromRegionName.text = [NSString stringWithFormat:@"%@ - %@",createdRide.FromEmirateEnName,createdRide.FromRegionEnName];
        _ToRegionName.text = [NSString stringWithFormat:@"%@ - %@",createdRide.ToEmirateEnName,createdRide.ToRegionEnName];
    }
    
    [self.firstButton setTitle:GET_STRING(@"Details") forState:UIControlStateNormal];
    [self.secondButton setTitle:GET_STRING(@"Edit") forState:UIControlStateNormal];
    [self.thirdButton setTitle:GET_STRING(@"Delete") forState:UIControlStateNormal];
}

- (NSString *)getAvailableDays:(DriverDetails *)rideDetails
{
    NSMutableString *str = [[NSMutableString alloc] init];
    
    if (rideDetails.Saturday.boolValue) {
        [str appendString:GET_STRING(@"Sat ")];
    }
    if (rideDetails.Sunday.boolValue) {
        [str appendString:GET_STRING(@"Sun ")];
    }
    if (rideDetails.Monday.boolValue) {
        [str appendString:GET_STRING(@"Mon ")];
    }
    if (rideDetails.Tuesday.boolValue) {
        [str appendString:GET_STRING(@"Tue ")];
    }
    if (rideDetails.Wendenday.boolValue) {
        [str appendString:GET_STRING(@"Wed ")];
    }
    if (rideDetails.Thrursday.boolValue) {
        [str appendString:GET_STRING(@"Thu ")];
    }
    if (rideDetails.Friday.boolValue) {
        [str appendString:GET_STRING(@"Fri ")];
    }
    
    return str ;
}
- (IBAction)firstButtonHandler:(id)sender {
    if (self.detailsHandler) {
        self.detailsHandler();
    }
}
- (IBAction)secondButtonHandler:(id)sender {
    if (self.createdRide) { // edit
        if (self.editHandler) {
            self.editHandler();
        }
    }
    else if (self.joinedRide){
        if (self.driverHandler) {
            self.driverHandler();
        }
    }
}

- (IBAction)thirdButtonHandler:(id)sender {
    if (self.createdRide) { // Delete
        if(self.deleteHandler){
            self.deleteHandler();
        }
    }
    else if(self.joinedRide){
        if(self.leaveHandler){
            self.leaveHandler();
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
