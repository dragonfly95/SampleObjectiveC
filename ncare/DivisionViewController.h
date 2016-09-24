//
//  DivisionViewController.h
//  ncare
// 

#import <UIKit/UIKit.h>
#import "HttpManager.h"

@protocol DivisionViewControllerDelegate;

@interface DivisionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, HttpManagerDelegate>

@property (weak) id <DivisionViewControllerDelegate> delegate;

@property (nonatomic, retain) HttpManager *httpManager;

@property (nonatomic, retain) NSString *campusTitle;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *birth;

@property (nonatomic, retain) NSArray *divisionArray;
@property (nonatomic, retain) NSDictionary *selectedDivision;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end


@protocol DivisionViewControllerDelegate <NSObject>

- (void)controller:(DivisionViewController *)controller didFinishSetDivision:(NSDictionary *)divisionDic;

@end