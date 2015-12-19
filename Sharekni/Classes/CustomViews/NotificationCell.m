//
//  NotificationCell.m
//  sharekni
//
//  Created by Ahmed Askar on 11/22/15.
//
//

#import "NotificationCell.h"
#import "Constants.h"

@implementation NotificationCell

- (void)awakeFromNib
{
    // Initialization code
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2.0f ;
    self.userImage.clipsToBounds = YES ;
    self.notificationLbl.textAlignment = NSTextAlignmentNatural ;
}

- (void)setNotification:(Notification *)notification
{
    if ([notification.DriverAccept boolValue]) {
        if (notification.DriverName) {
            self.notificationLbl.text = [NSString stringWithFormat:@"%@ %@",notification.DriverName,GET_STRING(@"Has Accepted your request")] ;
        }else{
            self.notificationLbl.text = GET_STRING(@"Has Accepted your request") ;
        }
    }else{
        if  (notification.isPending && notification.DriverName){
            self.notificationLbl.text = [NSString stringWithFormat:@"%@ %@",notification.DriverName,GET_STRING(@"Received your request and waiting for approval")] ;
        }
        else if (notification.DriverName) {
            self.notificationLbl.text = [NSString stringWithFormat:@"%@ %@",notification.DriverName,GET_STRING(@"Send you a join request")] ;
        }else{
            self.notificationLbl.text = GET_STRING(@"Send you a join request");
        }
    }
    self.nationality.text = (KIS_ARABIC)?notification.NationalityArName:notification.NationalityEnName ;
    if (notification.image) {
        self.userImage.image = notification.image ;
    }else{
        self.userImage.image = [UIImage imageNamed:@"thumbnail.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
