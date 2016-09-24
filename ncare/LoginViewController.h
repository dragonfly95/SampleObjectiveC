//
//  ViewController.h
//  ncare
//

#import <UIKit/UIKit.h>
#import "HttpManager.h"
#import "MainViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, HttpManagerDelegate>

@property (nonatomic, retain) HttpManager *httpManager;

@property (nonatomic, retain) NSString *idString;
@property (nonatomic, retain) NSString *pwString;

@property (nonatomic, retain) IBOutlet UITextField *idTextField;
@property (nonatomic, retain) IBOutlet UITextField *pwTextField;


- (BOOL)verifyUserInput;
- (void) animateTextField:(UITextField*)textField up:(BOOL)up;

- (IBAction)login:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LogoHeight;

@end

