//
//  AbsenceReasonViewController.h
//  ncare
//

#import <UIKit/UIKit.h>

@protocol AbsenceReasonViewControllerDelegate;

@interface AbsenceReasonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak) id <AbsenceReasonViewControllerDelegate> delegate;

@property (nonatomic, retain) NSArray *reasonArray;
@property (nonatomic, retain) NSString *selectedReason;


@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *sauTextField;



- (IBAction)setButtonClicked:(id)sender;

@end


@protocol AbsenceReasonViewControllerDelegate <NSObject>

- (void)controller:(AbsenceReasonViewController *)controller didFinishSetReason:(NSString *)reason;

@end