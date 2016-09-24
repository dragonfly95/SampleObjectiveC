//
//  ClassViewController.h
//  ncare
// 

#import <UIKit/UIKit.h>
#import "HttpManager.h"

@protocol ClassViewControllerDelegate;

@interface ClassViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, HttpManagerDelegate>

@property (weak) id <ClassViewControllerDelegate> delegate;

@property (nonatomic, retain) HttpManager *httpManager;

@property (nonatomic, retain) NSString *campusTitle;
@property (nonatomic, retain) NSString *divisionTitle;
@property (nonatomic, retain) NSString *gradeTitle;

@property (nonatomic, retain) NSArray *classArray;
@property (nonatomic, retain) NSDictionary *selectedClass;

@property (nonatomic, retain) IBOutlet UITableView *tableView;



@end


@protocol ClassViewControllerDelegate <NSObject>

- (void)controller:(ClassViewController *)controller didFinishSetClass:(NSDictionary *)classDic;

@end