//
//  GradeViewController.h
//  ncare
// 

#import <UIKit/UIKit.h>
#import "HttpManager.h"

@protocol GradeViewControllerDelegate;

@interface GradeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, HttpManagerDelegate>

@property (weak) id <GradeViewControllerDelegate> delegate;

@property (nonatomic, retain) HttpManager *httpManager;

@property (nonatomic, retain) NSString *campusTitle;
@property (nonatomic, retain) NSString *divisionTitle;

@property (nonatomic, retain) NSArray *gradeArray;
@property (nonatomic, retain) NSDictionary *selectedGrade;

@property (nonatomic, retain) IBOutlet UITableView *tableView;


@end


@protocol GradeViewControllerDelegate <NSObject>

- (void)controller:(GradeViewController *)controller didFinishSetGrade:(NSDictionary *)dradeDic;

@end