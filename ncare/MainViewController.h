//
//  MainViewController.h
//  ncare
//

#import <UIKit/UIKit.h>
#import "CampusViewController.h"
#import "DivisionViewController.h"
#import "GradeViewController.h"
#import "ClassViewController.h"
#import "StudentsAttendanceViewController.h"


@interface MainViewController : UIViewController <CampusViewControllerDelegate,
                                                  DivisionViewControllerDelegate,
                                                  GradeViewControllerDelegate,
                                                  ClassViewControllerDelegate>

@property (nonatomic, retain) NSString *codeList;  // 멀티 권한체크

@property (nonatomic, retain) NSString *campusCode;
@property (nonatomic, retain) NSString *campusTitle;
@property (nonatomic, retain) NSString *divisionCode;
@property (nonatomic, retain) NSString *divisionTitle;
@property (nonatomic, retain) NSString *gradeCode;
@property (nonatomic, retain) NSString *gradeTitle;
@property (nonatomic, retain) NSString *classCode;
@property (nonatomic, retain) NSString *classTitle;

@property (nonatomic, retain) IBOutlet UILabel *campusLabel;
@property (nonatomic, retain) IBOutlet UILabel *divisionLabel;
@property (nonatomic, retain) IBOutlet UILabel *gradeLabel;
@property (nonatomic, retain) IBOutlet UILabel *classLabel;
@property (nonatomic, retain) IBOutlet UIButton *campusButton;
@property (nonatomic, retain) IBOutlet UIButton *divisionButton;
@property (nonatomic, retain) IBOutlet UIButton *gradeButton;
@property (nonatomic, retain) IBOutlet UIButton *classButton;
@property (nonatomic, retain) IBOutlet UIButton *attendanceCheckButton;


@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *birth;

- (IBAction)selectCampus:(id)sender;
- (IBAction)selectDivision:(id)sender;
- (IBAction)selectGrade:(id)sender;
- (IBAction)selectClass:(id)sender;
- (IBAction)attendanceCheckButtonPressed:(id)sender;

@end
