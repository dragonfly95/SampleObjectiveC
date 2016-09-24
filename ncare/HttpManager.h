//
//  HttpManager.h
//  ncare
//
//  Created by kjd on 2014. 12. 28..
//  Copyright (c) 2014년 Onnuri. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpManagerDelegate;

@interface HttpManager : NSObject

@property (weak) id <HttpManagerDelegate> delegate;

+ (HttpManager *)sharedInstance;

- (void)loginWithID:(NSString *)uid AndPW:(NSString *)password;
- (void)logout;
//- (void)getCampus;
//- (void)getDivisionWithCampus:(NSString *)campusTitle;
- (void)getCampus:(NSString *)userName andBirth:(NSString *)birth;
- (void)getDivisionWithCampus:(NSString *)campusTitle andName:(NSString *)name andBirth:(NSString *)birth;
- (void)getGradeWithDivision:(NSString *)divisionTitle andCampus:(NSString *)campusTitle;
- (void)getClassWithGrade:(NSString *)gradeTitle andDivision:(NSString *)divisionTitle andCampus:(NSString *)campusTitle;
- (void)getStudentsWithClass:(NSString *)classCode;
- (void)addStudentsAttendanceInfo:(NSDictionary *)studentsDic;
- (void)updateStudentsAttendanceInfo:(NSDictionary *)studentsDic;

@end


#pragma mark delegate
@protocol HttpManagerDelegate <NSObject>

@optional
- (void)httpManager:(HttpManager *)httpManager didFinishLogin:(NSDictionary *)resultDictionary;
- (void)httpManager:(HttpManager *)httpManager didFinishLogout:(NSDictionary *)resultDictionary;
- (void)httpManager:(HttpManager *)httpManager didLoadCampus:(NSDictionary *)resultDictionary;
- (void)httpManager:(HttpManager *)httpManager didLoadDivision:(NSDictionary *)resultDictionary;
- (void)httpManager:(HttpManager *)httpManager didLoadGrade:(NSDictionary *)resultDictionary;
- (void)httpManager:(HttpManager *)httpManager didLoadClass:(NSDictionary *)resultDictionary;
- (void)httpManager:(HttpManager *)httpManager didLoadStudents:(NSDictionary *)resultDictionary;
- (void)httpManager:(HttpManager *)httpManager didFinishSaveStudents:(NSDictionary *)resultDictionary;

@end