//
//  StudentCellTableViewCell.h
//  ncare
// 

#import <UIKit/UIKit.h>

@interface StudentTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UISwitch *absenceSwitch;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@property (nonatomic, retain) IBOutlet UISwitch *visitSwitch;
@property (nonatomic, retain) IBOutlet UILabel *sauLabel;
@property (nonatomic, retain) IBOutlet UIButton *sauModiyButton;



@end
