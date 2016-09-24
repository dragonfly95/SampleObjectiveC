//
//  CampusViewController.h
//  ncare
// 

#import <UIKit/UIKit.h>
#import "HttpManager.h"

@protocol CampusViewControllerDelegate;

@interface CampusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, HttpManagerDelegate>

@property (weak) id <CampusViewControllerDelegate> delegate;

@property (nonatomic, retain) HttpManager *httpManager;

@property (nonatomic, retain) NSArray *campusArray;
@property (nonatomic, retain) NSDictionary *selectedCampus;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *birth;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end


@protocol CampusViewControllerDelegate <NSObject>

- (void)controller:(CampusViewController *)controller didFinishSetCampus:(NSDictionary *)campusDic;

@end