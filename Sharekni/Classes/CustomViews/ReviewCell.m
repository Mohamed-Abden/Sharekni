//
//  ReviewCell.m
//  sharekni
//
//  Created by Ahmed Askar on 11/4/15.
//
//

#import "ReviewCell.h"
#import "Constants.h"

@implementation ReviewCell

- (void)awakeFromNib
{
    // Initialization code
    self.driverPhoto.layer.cornerRadius = self.driverPhoto.frame.size.width / 2.0f ;
    self.driverPhoto.clipsToBounds = YES ;
    self.bgView.layer.cornerRadius = 3.0f;
}

- (void)setReview:(Review *)review
{
    self.driverPhoto.image = [UIImage imageNamed:@"thumbnail"];
    self.driverName.text = review.AccountName ;
    self.nationality.text = (KIS_ARABIC)?review.AccountNationalityAr:review.AccountNationalityEn ;
    if (review.Review && review.Review.length != 0)
    {
        self.bgView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        self.bgView.layer.borderWidth = 1.0f;
        self.bgView.layer.cornerRadius = 4.0f;
    }
    
    self.comment.text = [NSString stringWithFormat:@" %@ ",review.Review] ;
}

- (IBAction)edit:(id)sender
{
    if(self.editHandler){
        self.editHandler();
    }
}

- (IBAction)delete:(id)sender
{
    if (self.deleteHandler) {
        self.deleteHandler();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) showHideDelete:(BOOL)show{
    if (show) {
        self.deleteBtn.alpha = 1;
    }
    else{
        self.deleteBtn.alpha = 0;
    }
}
- (void) showHideEdit:(BOOL)show{
    if (show) {
        self.editBtn.alpha = 1;
    }
    else{
        self.editBtn.alpha = 0;
    }
}

@end
