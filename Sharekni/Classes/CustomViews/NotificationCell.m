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

- (void)awakeFromNib{
    // Initialization code
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2.0f ;
    self.userImage.clipsToBounds = YES ;
    self.notificationLbl.textAlignment = NSTextAlignmentNatural ;
       self.deleteRequestBtn.hidden = YES;
}

- (void)setNotification:(Notification *)notification{
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
        }else if (notification.PassengerName.length > 0){
            self.notificationLbl.text = [NSString stringWithFormat:@"%@ %@",notification.PassengerName,GET_STRING(@"Send you a join request")] ;;
        }
    }
    self.nationality.text = (KIS_ARABIC)?notification.NationalityArName:notification.NationalityEnName ;
    if (notification.image) {
        self.userImage.image = notification.image ;
    }else{
        self.userImage.image = [UIImage imageNamed:@"thumbnail.png"];
    }
    
//    if(notification.isPending){
//        self.deleteRequestBtn.alpha = 1;
//    }
//    else{
//        self.deleteRequestBtn.alpha = 0;
//    }
}
- (void)prepareForReuse{
       self.deleteRequestBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteHandler:(id)sender {
    if (self.deleteHandler) {
        self.deleteHandler();
    }
}

@end
