//
//  DivisionViewController.m
//  ncare
// 

#import "DivisionViewController.h"

@interface DivisionViewController ()

@end

@implementation DivisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"부서 설정"];

    self.httpManager = [HttpManager sharedInstance];
    self.httpManager.delegate = self;
    
    [self loadDivisionList];

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
 * 부서 리스트 가져오기 함수
 **/
- (void)loadDivisionList {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    [self.httpManager getDivisionWithCampus:self.campusTitle];
    [self.httpManager getDivisionWithCampus:self.campusTitle andName:self.name andBirth:self.birth];
}

#pragma mark - HttpManager Delegate Methods
// 부서 정보 수신시
- (void)httpManager:(HttpManager *)httpManager didLoadDivision:(NSDictionary *)resultDictionary {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    if ([[resultDictionary valueForKey:@"RESULT_OK"] isEqual:@"FAIL"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Load division data fail...\nPlease retry."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    self.divisionArray = [resultDictionary valueForKey:@"RESULT_DATA"];
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.divisionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *division = [self.divisionArray objectAtIndex:indexPath.row];
    NSLog(@"division %@", division);
    
    cell.textLabel.text = [division objectForKey:@"COMM"];
    
    return cell;
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 선택 결과 반환
    self.selectedDivision = [NSMutableDictionary dictionaryWithDictionary:[self.divisionArray objectAtIndex:indexPath.row]];
    [self.delegate controller:self didFinishSetDivision:self.selectedDivision];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
