//
//  ViewController.m
//  ncare
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize keyboardHeight;
@synthesize LogoHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.httpManager = [HttpManager sharedInstance];
    self.httpManager.delegate = self;
    
    self.idString = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID"];
    self.pwString = [[NSUserDefaults standardUserDefaults] stringForKey:@"PW"];
    
    [self.idTextField setText:self.idString];
    [self.pwTextField setText:self.pwString];
    
    [self observeKeyboard];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  아이디/패스워드 입력 검증 함수
 *  - 입력 오류를 판별한다.
 **/
- (BOOL)verifyUserInput {
    self.idString = [NSString stringWithString:self.idTextField.text];
    if (self.idString == nil || self.idString.length < 1) {
        // 아이디 입력 오류 알림
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"아이디를 입력해주세요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return FALSE;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.idString forKey:@"ID"];
    }
    
    self.pwString = [NSString stringWithString:self.pwTextField.text];
    if (self.pwString == nil || self.pwString.length < 1) {
        // 패스워드 입력 오류 알림
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"패스워드를 입력해주세요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return FALSE;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.pwString forKey:@"PW"];
    }
    
    return TRUE;
}


/**
 * 로그인 처리 함수
 *
 **/
- (IBAction)login:(id)sender {
    if ([self verifyUserInput]) {
        [self.httpManager loginWithID:self.idString AndPW:self.pwString];
    } else {
        
    }
}


#pragma mark - HttpManager Delegate Methods
// 로그인 결과 수신시
- (void)httpManager:(HttpManager *)httpManager didFinishLogin:(NSDictionary *)resultDictionary {
    if ([[resultDictionary valueForKey:@"RESULT_OK"] isEqual:@"FAIL"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"로그인 실패\n담당간사에게 문의바랍니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    NSDictionary *dataDictionary = [resultDictionary valueForKey:@"RESULT_DATA"];
    
    if ([[dataDictionary valueForKey:@"result"] isEqual:@"login"]) {
        // 메인 화면으로 이동
        MainViewController *mainViewController = [[MainViewController alloc] init];
        //    mainViewController.campusCode = [resultDictionary valueForKey:@"comm"];
        mainViewController.campusTitle = [dataDictionary valueForKey:@"kk"];
        mainViewController.divisionCode = [dataDictionary valueForKey:@"commcode"];
        mainViewController.divisionTitle = [dataDictionary valueForKey:@"comm"];
        mainViewController.codeList = [dataDictionary valueForKey:@"codelist"];
        mainViewController.name = [dataDictionary valueForKey:@"name"];
        mainViewController.birth = [dataDictionary valueForKey:@"birth"];
        
//        if ([dataDictionary valueForKey:@"codelist"] == [NSNull null]) {   // 권한 추가
//            mainViewController.codelist = nil;
//        } else {
//            mainViewController.codelist     = [dataDictionary valueForKey:@"codelist"];
//        }
//        
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
//        [self presentViewController:navigationController animated:YES completion:nil];
//    } else {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
//                                                        message:@"로그인 실패\n담당간사에게 문의바랍니다."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        
//        return;
//        
//    }

        if([dataDictionary valueForKey:@"codelist"] == (NSString *)[NSNull null]){
            
            mainViewController.codeList = @"null";
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"로그인 실패\n담당간사에게 문의바랍니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
        
    }

}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.idTextField) {
        [self.pwTextField becomeFirstResponder];
    } else if (textField == self.pwTextField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextField: textField up: YES];
    NSLog(@"textFieldDidBeginEditing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField: textField up: NO];
    NSLog(@"textFieldDidEndEditing");
}

/**
 * 화면 스크롤 처리 함수
 **/
- (void) animateTextField:(UITextField*)textField up:(BOOL)up {
    const int movementDistance = textField.frame.origin.y / 2;

    NSLog(@"size:: %i", 100);
    NSLog(@"size:: %i", movementDistance);
    
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}





////////
-(void) observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// The callback for frame-changing of keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    
    NSLog(@"Updating constraints.");
    // Because the "space" is actually the difference between the bottom lines of the 2 views,
    // we need to set a negative constant value here.
    self.keyboardHeight.constant = -height + 250;
    self.LogoHeight.constant = - 250;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.keyboardHeight.constant = 250;
    self.LogoHeight.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}


@end
