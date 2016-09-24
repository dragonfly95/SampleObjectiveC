//
//  HttpManager.m
//  ncare
//
//  Created by kjd on 2014. 12. 28..
//  Copyright (c) 2014년 Onnuri. All rights reserved.
//

#import "HttpManager.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define kServerUrl @"http://localhost:8084/child_ecare/rest"
#define kServerUrl @"http://icare.ionnuri.org/child_ecare/rest"


@implementation HttpManager

@synthesize delegate;

static HttpManager *singletonInstance;

+ (HttpManager *)sharedInstance
{
    if (singletonInstance == nil) {
        singletonInstance = [[HttpManager alloc] init];
    }
    
    return singletonInstance;
}


/**
 * 로그인 함수
 * - 아이디(uid)와 비밀번호(password)를 통해 로그인 한다.
 * - 로그인 성공시 소속 캠퍼스(kk), 학년(comm), 반(dlb) 정보를 반환한다.
 **/
- (void)loginWithID:(NSString *)uid AndPW:(NSString *)password {
    dispatch_async(kBgQueue, ^{
        NSError *err = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/login", kServerUrl];
        NSLog(@"loginWithIDAndPW urlString: %@", urlString);
        NSString* escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:escaped];
        
        NSDictionary *inputData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   uid,@"userid", password,@"passwd", nil];
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:inputData options:NSJSONWritingPrettyPrinted error:&err];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        NSLog(@"loginWithIDAndPW jsonInputString: %@", jsonInputString);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:[jsonInputString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"loginWithIDAndPW response: %@", response);
        
        NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
        if (response != nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ((long)[httpResponse statusCode] == 200) {
                NSLog(@"loginWithIDAndPW: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                
                id jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
                [resultDictionary setValue:@"SUCCESS" forKey:@"RESULT_OK"];
                [resultDictionary setValue:jsonResponseData forKey:@"RESULT_DATA"];
            } else {
                NSLog(@"loginWithIDAndPW fail err: %@", err);
                
                [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
                [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
            }
        } else {
            [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
            [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
        }
        
        [self performSelectorOnMainThread:@selector(parseLoginResponse:) withObject:resultDictionary waitUntilDone:YES];
    });
}

- (void)parseLoginResponse:(NSDictionary *)resultDictionary {
    [self.delegate httpManager:self didFinishLogin:resultDictionary];
}


/**
 * 로그아웃 함수
 *
 **/
- (void)logout {
    dispatch_async(kBgQueue, ^{
        NSError *err = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/logout", kServerUrl];
        NSLog(@"logout urlString: %@", urlString);
        NSString* escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:escaped];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        NSURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"logout response: %@", response);
        
        NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
        if (response != nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ((long)[httpResponse statusCode] == 200) {
                NSLog(@"logout: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                
                id jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
                [resultDictionary setValue:@"SUCCESS" forKey:@"RESULT_OK"];
                [resultDictionary setValue:jsonResponseData forKey:@"RESULT_DATA"];
            } else {
                NSLog(@"logout fail err: %@", err);
                
                [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
                [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
            }
        } else {
            [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
            [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
        }
        
        [self performSelectorOnMainThread:@selector(parseLogoutResponse:) withObject:resultDictionary waitUntilDone:YES];
    });
}

- (void)parseLogoutResponse:(NSDictionary *)resultDictionary {
    [self.delegate httpManager:self didFinishLogout:resultDictionary];
}


/**
 * 캠퍼스 정보 반환 함수
 *
 **/
- (void)getCampus:(NSString *)userName andBirth:(NSString *)birth {
    dispatch_async(kBgQueue, ^{
        NSError *err = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/comm/getCampusList/%@/%@", kServerUrl, userName, birth];
        NSLog(@"getCampus urlString: %@", urlString);
        NSString* escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:escaped];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        NSURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"getCampus response: %@", response);
        
        NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
        if (response != nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            
            //            NSLog((long)[httpResponse statusCode]);
            if ((long)[httpResponse statusCode] == 200) {
                NSLog(@"getCampus: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                
                id jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
                [resultDictionary setValue:@"SUCCESS" forKey:@"RESULT_OK"];
                [resultDictionary setValue:jsonResponseData forKey:@"RESULT_DATA"];
            } else {
                NSLog(@"getCampus fail err: %@", err);
                
                [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
                [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
            }
        } else {
            [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
            [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
        }
        
        [self performSelectorOnMainThread:@selector(parseCampusResponse:) withObject:resultDictionary waitUntilDone:YES];
    });
}

- (void)parseCampusResponse:(NSDictionary *)resultDictionary {
    [self.delegate httpManager:self didLoadCampus:resultDictionary];
}


/**
 * 부서 정보 반환 함수
 *
 **/
- (void)getDivisionWithCampus:(NSString *)campusTitle andName:(NSString *)name andBirth:(NSString *)birth {
    dispatch_async(kBgQueue, ^{
        NSError *err = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/comm/getBuseoList/%@/%@/%@", kServerUrl, name,birth,campusTitle];
        NSLog(@"getDivisionWithCampus urlString: %@", urlString);
        NSString* escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:escaped];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        NSURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"getDivisionWithCampus response: %@", response);
        
        NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
        if (response != nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ((long)[httpResponse statusCode] == 200) {
                NSLog(@"getDivisionWithCampus: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                
                id jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
                [resultDictionary setValue:@"SUCCESS" forKey:@"RESULT_OK"];
                [resultDictionary setValue:jsonResponseData forKey:@"RESULT_DATA"];
            } else {
                NSLog(@"getDivisionWithCampus fail err: %@", err);
                
                [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
                [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
            }
        } else {
            [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
            [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
        }
        
        [self performSelectorOnMainThread:@selector(parseDivisionResponse:) withObject:resultDictionary waitUntilDone:YES];
    });
}

- (void)parseDivisionResponse:(NSDictionary *)resultDictionary {
    [self.delegate httpManager:self didLoadDivision:resultDictionary];
}


/**
 * 학년 정보 반환 함수
 *
 **/
- (void)getGradeWithDivision:(NSString *)divisionTitle andCampus:(NSString *)campusTitle {
    dispatch_async(kBgQueue, ^{
        NSError *err = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/comm/get/%@/%@", kServerUrl, campusTitle, divisionTitle];
        NSLog(@"getGradeWithDivision urlString: %@", urlString);
        NSString* escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:escaped];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        NSURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"getGradeWithDivision response: %@", response);
        
        NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
        if (response != nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ((long)[httpResponse statusCode] == 200) {
                NSLog(@"getGradeWithDivision: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                
                id jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
                [resultDictionary setValue:@"SUCCESS" forKey:@"RESULT_OK"];
                [resultDictionary setValue:jsonResponseData forKey:@"RESULT_DATA"];
            } else {
                NSLog(@"getGradeWithDivision fail err: %@", err);
                
                [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
                [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
            }
        } else {
            [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
            [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
        }
        
        [self performSelectorOnMainThread:@selector(parseGradeResponse:) withObject:resultDictionary waitUntilDone:YES];
    });
}

- (void)parseGradeResponse:(NSDictionary *)resultDictionary {
    [self.delegate httpManager:self didLoadGrade:resultDictionary];
}


/**
 * 반 정보 반환 함수
 *
 **/
- (void)getClassWithGrade:(NSString *)gradeTitle andDivision:(NSString *)divisionTitle andCampus:(NSString *)campusTitle {
    dispatch_async(kBgQueue, ^{
        NSError *err = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/comm/get/%@/%@/%@", kServerUrl, campusTitle, divisionTitle, gradeTitle];
        NSLog(@"getClassWithGrade urlString: %@", urlString);
        NSString* escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:escaped];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        NSURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"getClassWithGrade response: %@", response);
        
        NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
        if (response != nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ((long)[httpResponse statusCode] == 200) {
                NSLog(@"getClassWithGrade: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                
                id jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
                [resultDictionary setValue:@"SUCCESS" forKey:@"RESULT_OK"];
                [resultDictionary setValue:jsonResponseData forKey:@"RESULT_DATA"];
            } else {
                NSLog(@"getClassWithGrade fail err: %@", err);
                
                [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
                [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
            }
        } else {
            [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
            [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
        }
        
        [self performSelectorOnMainThread:@selector(parseClassResponse:) withObject:resultDictionary waitUntilDone:YES];
    });
}

- (void)parseClassResponse:(NSDictionary *)resultDictionary {
    [self.delegate httpManager:self didLoadClass:resultDictionary];
}


/**
 * 학생 리스트 반환 함수
 * - 주어진 반(classCode)의 학생 리스트를 반환한다.
 **/
- (void)getStudentsWithClass:(NSString *)classCode {
    dispatch_async(kBgQueue, ^{
        NSError *err = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/banact/list/%@", kServerUrl, classCode];
        NSLog(@"getStudentsWithClass urlString: %@", urlString);
        NSString* escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:escaped];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        NSURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"getStudentsWithClass response: %@", response);
        
        NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
        if (response != nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ((long)[httpResponse statusCode] == 200) {
                NSLog(@"getStudentsWithClass: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                
                id jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
                [resultDictionary setValue:@"SUCCESS" forKey:@"RESULT_OK"];
                [resultDictionary setValue:jsonResponseData forKey:@"RESULT_DATA"];
            } else {
                NSLog(@"getStudentsWithClass fail err: %@", err);
                
                [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
                [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
            }
        } else {
            [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
            [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
        }
        
        [self performSelectorOnMainThread:@selector(parseStudentsResponse:) withObject:resultDictionary waitUntilDone:YES];
    });
}

- (void)parseStudentsResponse:(NSDictionary *)resultDictionary {
    [self.delegate httpManager:self didLoadStudents:resultDictionary];
}


/**
 * 출석부 저장함수 (최초 생성)
 *
 **/
- (void)addStudentsAttendanceInfo:(NSDictionary *)studentsDic {
    dispatch_async(kBgQueue, ^{
        NSError *err = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/banact/choolsuk_add", kServerUrl];
        NSLog(@"addStudentsAttendanceInfo urlString: %@", urlString);
        NSString* escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:escaped];
        
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:studentsDic options:NSJSONWritingPrettyPrinted error:&err];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        NSLog(@"addStudentsAttendanceInfo jsonInputString: %@", jsonInputString);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:[jsonInputString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"addStudentsAttendanceInfo response: %@", response);
        
        NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
        if (response != nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ((long)[httpResponse statusCode] == 200) {
                NSLog(@"addStudentsAttendanceInfo: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                
                id jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
                [resultDictionary setValue:@"SUCCESS" forKey:@"RESULT_OK"];
                [resultDictionary setValue:jsonResponseData forKey:@"RESULT_DATA"];
            } else {
                NSLog(@"addStudentsAttendanceInfo fail err: %@", err);
                
                [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
                [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
            }
        } else {
            [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
            [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
        }
        
        [self performSelectorOnMainThread:@selector(parseStudentsAttendanceResponse:) withObject:resultDictionary waitUntilDone:YES];
    });
}

- (void)parseStudentsAttendanceResponse:(NSDictionary *)resultDictionary {
    [self.delegate httpManager:self didFinishSaveStudents:resultDictionary];
}


/**
 * 출석부 업데이트 함수 (출석부가 존재할 경우 호출)
 *
 **/
- (void)updateStudentsAttendanceInfo:(NSDictionary *)studentsDic {
    dispatch_async(kBgQueue, ^{
        NSError *err = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/banact/choolsuk_update", kServerUrl];
        NSLog(@"updateStudentsAttendanceInfo urlString: %@", urlString);
        NSString* escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:escaped];
        
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:studentsDic options:NSJSONWritingPrettyPrinted error:&err];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        NSLog(@"updateStudentsAttendanceInfo jsonInputString: %@", jsonInputString);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:[jsonInputString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSLog(@"updateStudentsAttendanceInfo response: %@", response);
        
        NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
        if (response != nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ((long)[httpResponse statusCode] == 200) {
                NSLog(@"updateStudentsAttendanceInfo: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                
                id jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
                [resultDictionary setValue:@"SUCCESS" forKey:@"RESULT_OK"];
                [resultDictionary setValue:jsonResponseData forKey:@"RESULT_DATA"];
            } else {
                NSLog(@"updateStudentsAttendanceInfo fail err: %@", err);
                
                [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
                [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
            }
        } else {
            [resultDictionary setValue:@"FAIL" forKey:@"RESULT_OK"];
            [resultDictionary setValue:nil forKey:@"RESULT_DATA"];
        }
        
        [self performSelectorOnMainThread:@selector(parseStudentsAttendanceResponse:) withObject:resultDictionary waitUntilDone:YES];
    });
}
@end
