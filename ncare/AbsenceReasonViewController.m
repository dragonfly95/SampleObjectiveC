//
//  AbsenceReasonViewController.m
//  ncare
//

#import "AbsenceReasonViewController.h"

@interface AbsenceReasonViewController ()

@end

@implementation AbsenceReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"결석 사유"];
    
    self.reasonArray = [NSArray arrayWithObjects:@"사유를 알지 못하는 결석",
                                                 @"늦잠 등의 단순 사유 결석",
                                                 @"병으로 인한 결석",
                                                 @"시험, 학원 등으로 인한 결석",
                                                 @"가정사로 인한 결석",
                                                 @"다른교회 참석",
                                                 @"인정되지 않은 다른예배 출석",
                                                 @"언어연수 등의 장기 연수로 인한 결석", nil];
    
    [self.sauTextField setReturnKeyType:UIReturnKeyDone];
    
    [self.tableView reloadData];
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
 * 설정 버튼 클릭 처리 함수 
 * - 선택하거나 입력한 결석 사유을 델리게이터를 통해 반환한다.
 **/
- (IBAction)setButtonClicked:(id)sender {
    [self.delegate controller:self didFinishSetReason:[self.sauTextField text]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reasonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *reason = [self.reasonArray objectAtIndex:indexPath.row];
    NSLog(@"reason %@", reason);
    
    cell.textLabel.text = reason;
    
    return cell;
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedReason = [self.reasonArray objectAtIndex:indexPath.row];
    [self.sauTextField setText:self.selectedReason];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.sauTextField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
