//
//  AttendanceViewController.m
//  ncare
//

#import "StudentsAttendanceViewController.h"

@interface StudentsAttendanceViewController ()

@end

@implementation StudentsAttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.httpManager = [HttpManager sharedInstance];
    self.httpManager.delegate = self;
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"출석부"];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"저장" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    NSString *classTitle = [NSString stringWithFormat:@"%@ / %@ / %@ / %@", self.campusTitle, self.divisionTitle, self.gradeTitle, self.classTitle];
    [self.classLabel setText:classTitle];
    
//    NSDate *today = [NSDate date];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *weekdayComponent = [calendar components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
//    
//    NSInteger year = [weekdayComponent year];
//    NSInteger month = [weekdayComponent month];
//    NSInteger day = [weekdayComponent day];
//    NSInteger weekday = [weekdayComponent weekday];
//    NSArray *dayArray = [[NSArray alloc] initWithObjects:@"", @"일요일", @"월요일", @"화요일", @"수요일", @"목요일", @"금요일", @"토요일", nil];
//    
//    NSString *dateString = [NSString stringWithFormat:@"%d년 %d월 %d일 (%@)",  year, month, day, [dayArray objectAtIndex:weekday]];
//    [self.dateLabel setText:dateString];
    
    [self loadStudentList];
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
 * 학생 리스트 가져오기 함수
 **/
- (void)loadStudentList {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self.httpManager getStudentsWithClass:self.classCode];
}

#pragma mark - HttpManager Delegate Methods
// 반별 학생 정보 수신시
- (void)httpManager:(HttpManager *)httpManager didLoadStudents:(NSDictionary *)resultDictionary {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([[resultDictionary valueForKey:@"RESULT_OK"] isEqual:@"FAIL"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Load studests fail...\nPlease retry."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    NSDictionary *studentsDictionary = [resultDictionary valueForKey:@"RESULT_DATA"];
    self.studentArray = [NSMutableArray arrayWithArray:[studentsDictionary objectForKey:@"list"]];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *classTitle = [NSString stringWithFormat:@"%@ / %@ / %@ / %@ (%d 명)", self.campusTitle, self.divisionTitle, self.gradeTitle, self.classTitle, (int)[self.studentArray count]];
    [self.classLabel setText:classTitle];

    self.bogoDayCount = [[studentsDictionary valueForKey:@"bogoday_cnt"] integerValue];
    
    self.dateString = [studentsDictionary objectForKey:@"bogoday"];
    NSString *year = [self.dateString substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [self.dateString substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [self.dateString substringWithRange:NSMakeRange(6, 2)];
    [self.dateLabel setText:[NSString stringWithFormat:@"%@년 %@월 %@일", year, month, day]];
    
    // 데이터 수신후 화면 갱신
    [self.tableView reloadData];
}

// 출석부 저장 결과 수신시
- (void)httpManager:(HttpManager *)httpManager didFinishSaveStudents:(NSDictionary *)resultDictionary {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([[resultDictionary valueForKey:@"RESULT_OK"] isEqual:@"FAIL"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"출석부를 저장하지 못했습니다.\n다시 시도해 주세요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    NSDictionary *resultDic = [resultDictionary valueForKey:@"RESULT_DATA"];
    NSString *result = [resultDic objectForKey:@"result"];
    if ([result isEqualToString:@"ok"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"출석부를 저장하였습니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([result isEqualToString:@"이미등록했습니다."]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"이미 등록했습니다"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

/**
 * 저장 버튼 클릭시 : 출석부 저장 처리 함수
 **/
- (void)saveButtonClicked:(id)sender {
    //
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSMutableString *sauListString = [[NSMutableString alloc] init];
    for (int i=0; i<self.studentArray.count; i++) {
        NSDictionary *studentDic = [self.studentArray objectAtIndex:i];
        NSString *sauString = [studentDic objectForKey:@"sau"];
        [sauListString appendFormat:@"%@:", sauString];
    }
    NSString *sauString = [sauListString substringToIndex:sauListString.length-1];

    if (self.bogoDayCount > 0) {
        // 출석부 업데이트
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.studentArray forKey:@"list"];
        [dic setObject:sauString forKey:@"sau_arr"];
        [dic setObject:self.dateString forKey:@"bogoday"];
        [dic setObject:self.campusTitle forKey:@"kk"];
        [dic setObject:self.divisionTitle forKey:@"comm"];
        [dic setObject:self.gradeTitle forKey:@"dlb"];
        [dic setObject:self.classTitle forKey:@"soon"];
        
        [self.httpManager updateStudentsAttendanceInfo:dic];
    } else {
        // 출석부 저장
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.studentArray forKey:@"list"];
        [dic setObject:sauString forKey:@"sau_arr"];
        [dic setObject:self.campusTitle forKey:@"kk"];
        [dic setObject:self.divisionTitle forKey:@"comm"];
        [dic setObject:self.gradeTitle forKey:@"dlb"];
        [dic setObject:self.classTitle forKey:@"soon"];
        
        [self.httpManager addStudentsAttendanceInfo:dic];
    }
}

/**
 * 출석 버튼 클릭시 : 출결 체크 함수
 **/
- (void)absenceSwitchChanged:(UISwitch *)sender {
    //
    self.selectedStudent = [NSMutableDictionary dictionaryWithDictionary:[self.studentArray objectAtIndex:sender.tag]];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    StudentTableViewCell *cell = (StudentTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([[self.selectedStudent objectForKey:@"attend_yn"] isEqualToString:@"Y"]) {
        [self.selectedStudent setValue:@"N" forKey:@"attend_yn"];
        
        [self.studentArray replaceObjectAtIndex:sender.tag withObject:self.selectedStudent];

        [cell.sauLabel setHidden:NO];
        [cell.sauModiyButton setHidden:NO];
        
        // 결석 사유 처리 화면으로 이동
        AbsenceReasonViewController *controller = [[AbsenceReasonViewController alloc] init];
        controller.delegate = self;
        [self.navigationController pushViewController: controller animated:YES];
    } else {
        [self.selectedStudent setValue:@"Y" forKey:@"attend_yn"];
        [self.selectedStudent setValue:@" " forKey:@"sau"];
        
        [self.studentArray replaceObjectAtIndex:sender.tag withObject:self.selectedStudent];

        [cell.sauLabel setHidden:YES];
        [cell.sauModiyButton setHidden:YES];
    }
}

/**
 * 심방 버튼 클릭시 : 심방 요청 체크
 **/
- (void)visitSwitchChanged:(UISwitch *)sender {
    //
    self.selectedStudent = [NSMutableDictionary dictionaryWithDictionary:[self.studentArray objectAtIndex:sender.tag]];

    NSString *simbangString = [self.selectedStudent objectForKey:@"simbang_yn"];
    if (![simbangString isKindOfClass:[NSNull class]] && [simbangString isEqualToString:@"Y"]) {
        [self.selectedStudent setValue:@"N" forKey:@"simbang_yn"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"심방취소"
                                                        message:@"심방 취소하였습니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];        
    } else {
        [self.selectedStudent setValue:@"Y" forKey:@"simbang_yn"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"심방신청"
                                                        message:@"심방 신청하였습니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self.studentArray replaceObjectAtIndex:sender.tag withObject:self.selectedStudent];
}

/**
 * 결석 사유 수정 버튼 클릭시 : 사유 수정 처리
 **/
- (void)modiySauButtonClicked:(UIButton *)sender {
    //
    self.selectedStudent = [NSMutableDictionary dictionaryWithDictionary:[self.studentArray objectAtIndex:sender.tag]];
    [self.studentArray replaceObjectAtIndex:sender.tag withObject:self.selectedStudent];
    
    // 결석 사유 처리 화면으로 이동
    AbsenceReasonViewController *controller = [[AbsenceReasonViewController alloc] init];
    controller.delegate = self;
    [self.navigationController pushViewController: controller animated:YES];
}

#pragma mark - AbsenceReasonViewController Delegate Methods
// 결석 사유 결과 수신시
- (void)controller:(AbsenceReasonViewController *)controller didFinishSetReason:(NSString *)reason {
    // 결석 사유 설정
    [self.selectedStudent setValue:reason forKey:@"sau"];
    
    // 화면 갱신
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.studentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"StudentTableViewCell";
    StudentTableViewCell *cell = (StudentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[StudentTableViewCell class]]) {
                cell = (StudentTableViewCell *)oneObject;
            }
        }
    }
    
    // 셀 설정
    NSDictionary *student = [self.studentArray objectAtIndex:indexPath.row];
    NSLog(@"student %@", student);
    
    if ([[student objectForKey:@"attend_yn"] isEqualToString:@"Y"]) {
        [cell.absenceSwitch setOn:true];
        [cell.sauLabel setHidden:YES];
        [cell.sauModiyButton setHidden:YES];
    } else {
        [cell.absenceSwitch setOn:false];
        [cell.sauLabel setHidden:NO];
        [cell.sauModiyButton setHidden:NO];
    }
    cell.absenceSwitch.tag = indexPath.row;
    [cell.absenceSwitch addTarget:self action:@selector(absenceSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [student objectForKey:@"name"], [student objectForKey:@"birth"]];
    
    cell.sauLabel.text = [student objectForKey:@"sau"];
    
    NSString *simbangString = [student objectForKey:@"simbang_yn"];
    NSLog(@"simbangString %@", simbangString);
    if (![simbangString isKindOfClass:[NSNull class]] && [simbangString isEqualToString:@"Y"]) {
        [cell.visitSwitch setOn:YES];
    } else {
        [cell.visitSwitch setOn:NO];
    }
    cell.visitSwitch.tag = indexPath.row;
    [cell.visitSwitch addTarget:self action:@selector(visitSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];

    cell.sauModiyButton.tag = indexPath.row;
    [cell.sauModiyButton addTarget:self action:@selector(modiySauButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedStudent = [NSMutableDictionary dictionaryWithDictionary:[self.studentArray objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
