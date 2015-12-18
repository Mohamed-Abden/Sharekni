//
//  BestDriverCell.m
//  Sharekni
//
//  Created by Ahmed Askar on 9/26/15.
//
//

#import "BestDriverCell.h"
#import "RZDataBinding.h"
#import "Constants.h"

@implementation BestDriverCell

- (void)awakeFromNib
{
    // Initialization code
    self.driverImage.layer.cornerRadius = self.driverImage.frame.size.width / 2.0f ;
    self.driverImage.clipsToBounds = YES ;
}

- (void)setDriver:(BestDriver *)driver
{
    _driver = driver;
    self.driverName.text = driver.AccountName ;
    self.driverCountry.text = (KIS_ARABIC)?driver.NationalityArName:driver.NationalityEnName ;
    if (driver.image) {
        self.driverImage.image = self.driver.image;
    }
    else{
        self.driverImage.image = [UIImage imageNamed:@"thumbnail.png"];
        [self.driver rz_addTarget:self action:@selector(imageChanged) forKeyPathChange:@"driverImage" callImmediately:YES];
    }
   [self.driver rz_addTarget:self action:@selector(RatingChanged) forKeyPathChange:@"Rating" callImmediately:YES];
    self.phone = driver.AccountMobile ;
}

- (void) imageChanged{
     self.driverImage.image = self.driver.image;
}
- (void) RatingChanged{
     self.rateLbl.text = self.driver.Rating;
}


- (IBAction)sendMail:(id)sender
{
    [self.delegate sendSMSFromPhone:self.phone];
}

- (IBAction)call:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel:%@",self.phone]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
