//
//  AttendanceViewController.h
//  ncare
//

#import <UIKit/UIKit.h>
#import "HttpManager.h"
#import "StudentTableViewCell.h"
#import "AbsenceReasonViewController.h"

@interface StudentsAttendanceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, HttpManagerDelegate, AbsenceReasonViewControllerDelegate>

@property (nonatomic, retain) HttpManager *httpManager;

@property (nonatomic, retain) NSString *campusTitle;
@property (nonatomic, retain) NSString *divisionTitle;
@property (nonatomic, retain) NSString *gradeTitle;
@property (nonatomic, retain) NSString *classTitle;
@property (nonatomic, retain) NSString *classCode;

@property (nonatomic, retain) NSMutableArray *studentArray;
@property (nonatomic, retain) NSDictionary *selectedStudent;
@property (nonatomic, assign) NSUInteger bogoDayCount;
@property (nonatomic, retain) NSString *dateString;

@property (nonatomic, retain) IBOutlet UILabel *classLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
