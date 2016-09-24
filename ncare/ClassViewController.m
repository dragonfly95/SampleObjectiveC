//
//  ClassViewController.m
//  ncare
//

#import "ClassViewController.h"

@interface ClassViewController ()

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"반 설정"];

    self.httpManager = [HttpManager sharedInstance];
    self.httpManager.delegate = self;
    
    [self loadClassList];
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
 * 반 리스트 가져오기 함수
 **/
- (void)loadClassList {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.httpManager getClassWithGrade:self.gradeTitle andDivision:self.divisionTitle andCampus:self.campusTitle];
}

#pragma mark - HttpManager Delegate Methods
// 반 정보 수신시
- (void)httpManager:(HttpManager *)httpManager didLoadClass:(NSDictionary *)resultDictionary {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([[resultDictionary valueForKey:@"RESULT_OK"] isEqual:@"FAIL"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Load class fail...\nPlease retry."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    self.classArray = [resultDictionary valueForKey:@"RESULT_DATA"];
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *class = [self.classArray objectAtIndex:indexPath.row];
    NSLog(@"class %@", class);
    
    cell.textLabel.text = [class objectForKey:@"SOON"];
    
    return cell;
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 선택 결과 반환
    self.selectedClass = [NSMutableDictionary dictionaryWithDictionary:[self.classArray objectAtIndex:indexPath.row]];
    [self.delegate controller:self didFinishSetClass:self.selectedClass];
    
    // 종료
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
