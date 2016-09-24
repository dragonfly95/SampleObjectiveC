//
//  CampusViewController.m
//  ncare
//

#import "CampusViewController.h"

@interface CampusViewController ()

@end

@implementation CampusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"캠퍼스 설정"];

    self.httpManager = [HttpManager sharedInstance];
    self.httpManager.delegate = self;
    
    [self loadCampusList];

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
 * 캠퍼스 리스트 가져오기 함수
 **/
- (void)loadCampusList {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    [self.httpManager getCampus];
    [self.httpManager getCampus:self.name andBirth: self.birth];
}

#pragma mark - HttpManager Delegate Methods
// 캠퍼스 정보 수신시
- (void)httpManager:(HttpManager *)httpManager didLoadCampus:(NSDictionary *)resultDictionary {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([[resultDictionary valueForKey:@"RESULT_OK"] isEqual:@"FAIL"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Load campus fail...\nPlease retry."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    self.campusArray = [resultDictionary valueForKey:@"RESULT_DATA"];
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.campusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *campus = [self.campusArray objectAtIndex:indexPath.row];
    NSLog(@"campus %@", campus);
    
    cell.textLabel.text = [campus objectForKey:@"KK"];
    
    return cell;
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 선택 결과 반환
    self.selectedCampus = [NSMutableDictionary dictionaryWithDictionary:[self.campusArray objectAtIndex:indexPath.row]];
    [self.delegate controller:self didFinishSetCampus:self.selectedCampus];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
