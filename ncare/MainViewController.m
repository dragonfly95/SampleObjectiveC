//
//  MainViewController.m
//  ncare
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"nCare 출석 체크"];
    
    [self.campusLabel setText:self.campusTitle];
    
    if([self.codeList isEqual:@"null"]){
        
        [self.divisionButton setHidden:YES];
        [self.campusButton setHidden:YES];
        
    }else{
        [self.campusLabel setText:self.campusTitle];
    }
    
    if (self.campusTitle == nil) {
        self.campusTitle = @"캠퍼스를 설정해 주세요";
    }
    
    if (self.divisionCode == nil) {
        self.divisionTitle = @"부서를 설정해 주세요";
        
    } else {
        
        
    }
    [self.divisionLabel setText:self.divisionTitle];
    
    if (self.gradeCode == nil) {
        self.gradeTitle = @"학년를 설정해 주세요";
    }
    [self.gradeLabel setText:self.gradeTitle];
    
    if (self.classCode == nil) {
        self.classTitle = @"반를 설정해 주세요";
    }
    [self.classLabel setText:self.classTitle];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


/**
 * 캠퍼스 선택 처리 함수
 **/
- (IBAction)selectCampus:(id)sender {
    // 캠퍼스 선택 처리
    CampusViewController *controller = [[CampusViewController alloc] init];
    controller.delegate = self;
    controller.name = self.name;
    controller.birth = self.birth;
    [self.navigationController pushViewController: controller animated:YES];
}

#pragma mark - CampusViewController Delegate Methods
// 캠퍼스 선택 결과 수신시
- (void)controller:(CampusViewController *)controller didFinishSetCampus:(NSDictionary *)campusDic {
    if (campusDic != nil) {
        self.campusCode = [campusDic objectForKey:@"KK"];
        self.campusTitle = [campusDic objectForKey:@"KK"];
        
        [self.campusLabel setText:self.campusTitle];
        
        self.divisionCode = nil;
        self.divisionTitle = @"부서를 설정해 주세요";
        [self.divisionLabel setText:self.divisionTitle];
        
        self.gradeCode = nil;
        self.gradeTitle = @"학년를 설정해 주세요";
        [self.gradeLabel setText:self.gradeTitle];
        
        self.classCode = nil;
        self.classTitle = @"반를 설정해 주세요";
        [self.classLabel setText:self.classTitle];
    }
}

/**
 * 부서 선택 처리 함수
 **/
- (IBAction)selectDivision:(id)sender {
    //    if (self.campusCode == nil) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
    //                                                        message:@"캠퍼스를 설정해 주세요."
    //                                                       delegate:nil
    //                                              cancelButtonTitle:@"OK"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //
    //        return;
    //    }
    
    // 부서 선택 처리
    DivisionViewController *controller = [[DivisionViewController alloc] init];
    controller.delegate = self;
    controller.campusTitle = self.campusTitle;
    controller.name = self.name;
    controller.birth = self.birth;
    [self.navigationController pushViewController: controller animated:YES];
}

#pragma mark - DivisionViewController Delegate Methods
// 부서 선택 결과 수신시
- (void)controller:(DivisionViewController *)controller didFinishSetDivision:(NSDictionary *)divisionDic {
    if (divisionDic != nil) {
        self.divisionCode = [divisionDic objectForKey:@"COMM"];
        self.divisionTitle = [divisionDic objectForKey:@"COMM"];
        [self.divisionLabel setText:self.divisionTitle];
        
        self.gradeCode = nil;
        self.gradeTitle = @"학년를 설정해 주세요";
        [self.gradeLabel setText:self.gradeTitle];
        
        self.classCode = nil;
        self.classTitle = @"반를 설정해 주세요";
        [self.classLabel setText:self.classTitle];
    }
}

/**
 * 학년 선택 처리 함수
 **/
- (IBAction)selectGrade:(id)sender {
    //    if (self.campusCode == nil) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
    //                                                        message:@"캠퍼스를 설정해 주세요."
    //                                                       delegate:nil
    //                                              cancelButtonTitle:@"OK"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //
    //        return;
    //    }
    
    if (self.divisionCode == nil) {
        [self.divisionButton setHidden:NO];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"부서를 설정해 주세요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // 학년 선택 처리
    GradeViewController *controller = [[GradeViewController alloc] init];
    controller.delegate = self;
    controller.campusTitle = self.campusTitle;
    controller.divisionTitle = self.divisionTitle;
    [self.navigationController pushViewController: controller animated:YES];
}

#pragma mark - GradeViewController Delegate Methods
// 학년 선택 결과 수신시
- (void)controller:(GradeViewController *)controller didFinishSetGrade:(NSDictionary *)gradeDic {
    if (gradeDic != nil) {
        self.gradeCode = [gradeDic objectForKey:@"COMMCODE"];
        self.gradeTitle = [gradeDic objectForKey:@"DLB"];
        [self.gradeLabel setText:self.gradeTitle];
        NSLog(@"self.gradeTitle %@", self.gradeTitle);
        
        if ([self.gradeTitle isEqualToString:@"전체"]) {
            self.classCode = self.gradeCode;
            self.classTitle = @"전체";
            [self.classLabel setText:self.classTitle];
            [self.classButton setHidden:YES];
        } else {
            self.classCode = nil;
            self.classTitle = @"반를 설정해 주세요";
            [self.classLabel setText:self.classTitle];
            [self.classButton setHidden:NO];
        }
    }
}

/**
 * 반 선택 처리 함수
 **/
- (IBAction)selectClass:(id)sender {
    //    if (self.campusCode == nil) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
    //                                                        message:@"캠퍼스를 설정해 주세요."
    //                                                       delegate:nil
    //                                              cancelButtonTitle:@"OK"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //
    //        return;
    //    }
    
    if (self.divisionCode == nil) {
        [self.divisionButton setHidden:NO];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"부서를 설정해 주세요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (self.gradeCode == nil) {
        [self.gradeButton setHidden:NO];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"학년을 설정해 주세요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // 반 선택 처리
    ClassViewController *controller = [[ClassViewController alloc] init];
    controller.delegate = self;
    controller.campusTitle = self.campusTitle;
    controller.divisionTitle = self.divisionTitle;
    controller.gradeTitle = self.gradeTitle;
    [self.navigationController pushViewController: controller animated:YES];
}

#pragma mark - ClassViewController Delegate Methods
// 반 선택 결과 수신시
- (void)controller:(ClassViewController *)controller didFinishSetClass:(NSDictionary *)classDic {
    if (classDic != nil) {
        self.classCode = [classDic objectForKey:@"COMMCODE"];
        self.classTitle = [classDic objectForKey:@"SOON"];
        [self.classLabel setText:self.classTitle];
    }
}

/**
 * 출석 체크 처리 함수
 **/
- (IBAction)attendanceCheckButtonPressed:(id)sender {
    //    if (self.campusCode == nil) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
    //                                                        message:@"캠퍼스를 설정해 주세요."
    //                                                       delegate:nil
    //                                              cancelButtonTitle:@"OK"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //
    //        return;
    //    }
    
    if (self.divisionCode == nil) {
        [self.divisionButton setHidden:NO];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"부서를 설정해 주세요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (self.gradeCode == nil) {
        [self.gradeButton setHidden:NO];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"학년을 설정해 주세요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (self.classCode == nil) {
        [self.classButton setHidden:NO];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"반을 설정해 주세요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // 출석 체크 처리
    StudentsAttendanceViewController *controller = [[StudentsAttendanceViewController alloc] init];
    controller.campusTitle = self.campusTitle;
    controller.divisionTitle = self.divisionTitle;
    controller.gradeTitle = self.gradeTitle;
    controller.classTitle = self.classTitle;
    controller.classCode = self.classCode;
    [self.navigationController pushViewController: controller animated:YES];
}

@end
