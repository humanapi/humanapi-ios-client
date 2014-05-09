//
//  HumanAPIClientTests.m
//  HumanAPIClient implementation tests
//

#import <XCTest/XCTest.h>
#import "XCTestCase+AsyncTesting.h"
#import "HumanAPIClient.h"

@interface HumanAPIClientTests : XCTestCase

@end

@implementation HumanAPIClientTests

- (void)setUp
{
    [super setUp];
    
    // set access token
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    client.accessToken = @"demo";
    
    // Put setup code here.
}

- (void)tearDown
{
    // Put teardown code here.
    [super tearDown];
}

// Human Entity

- (void)testHumanGet
{
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client human] getWithOnSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertNotNil(res[@"activitySummary"]);
        XCTAssertEqualObjects(@"52e20cb2fff56aac62000001", res[@"userId"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
}

// Profile Entity

- (void)testProfileGet
{
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client profile] getWithOnSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertEqualObjects(@"52e20cb2fff56aac62000001", res[@"userId"]);
        XCTAssertEqualObjects(@"demo@humanapi.co", res[@"email"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
}

// Genetic Trait Entity

- (void)testGeneticTraitList
{
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client geneticTrait] listWithOnSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSArray *res = (NSArray *)responseObject;
        XCTAssertTrue([res count] > 0);
        NSDictionary *obj = [res objectAtIndex:0];
        XCTAssertNotNil(obj[@"userId"]);
        XCTAssertNotNil(obj[@"trait"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
}

// Blood Glucose Entity

- (void)testBloodGlucoseLatest
{
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client bloodGlucose] latestWithOnSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertNotNil(res[@"id"]);
        XCTAssertNotNil(res[@"timestamp"]);
        XCTAssertNotNil(res[@"value"]);
        XCTAssertNotNil(res[@"source"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
}

- (void)testBloodGlucoseReadings
{
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client bloodGlucose] readingsWithOnSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSArray *res = (NSArray *)responseObject;
        XCTAssertTrue([res count] > 0);
        NSDictionary *obj = [res objectAtIndex:0];
        XCTAssertNotNil(obj[@"id"]);
        XCTAssertNotNil(obj[@"timestamp"]);
        XCTAssertNotNil(obj[@"value"]);
        XCTAssertNotNil(obj[@"source"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
}

- (void)testBloodGlucoseReading
{
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client bloodGlucose] reading:@"52e20cb3fff56aac6200044a" onSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertNotNil(res[@"id"]);
        XCTAssertNotNil(res[@"timestamp"]);
        XCTAssertNotNil(res[@"value"]);
        XCTAssertNotNil(res[@"source"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
}

- (void)testBloodGlucoseDaily
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *day = [dateFormat dateFromString:@"2014-01-23"];
    
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client bloodGlucose] dailyForDay:day onSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSArray *res = (NSArray *)responseObject;
        XCTAssertTrue([res count] > 0);

        NSDictionary *obj = [res objectAtIndex:0];
        XCTAssertNotNil(obj[@"id"]);
        XCTAssertNotNil(obj[@"timestamp"]);
        XCTAssertNotNil(obj[@"value"]);
        XCTAssertNotNil(obj[@"source"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
    
}

// Activity Entity

- (void)testActivityList
{
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client activity] listWithOnSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSArray *res = (NSArray *)responseObject;
        XCTAssertTrue([res count] > 0);
        
        NSDictionary *obj = [res objectAtIndex:0];
        XCTAssertNotNil(obj[@"id"]);
        XCTAssertNotNil(obj[@"startTime"]);
        XCTAssertNotNil(obj[@"duration"]);
        XCTAssertNotNil(obj[@"source"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
    
}

- (void)testActivityGet
{
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client activity] get:@"52e20cb5fff56aac62000b73" onSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertNotNil(res[@"id"]);
        XCTAssertNotNil(res[@"startTime"]);
        XCTAssertNotNil(res[@"duration"]);
        XCTAssertNotNil(res[@"source"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
}

- (void)testActivityDaily
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *day = [dateFormat dateFromString:@"2014-01-24"];
    
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client activity] dailyForDay:day onSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSArray *res = (NSArray *)responseObject;
        XCTAssertTrue([res count] > 0);
        
        NSDictionary *obj = [res objectAtIndex:0];
        XCTAssertNotNil(obj[@"id"]);
        XCTAssertNotNil(obj[@"startTime"]);
        XCTAssertNotNil(obj[@"duration"]);
        XCTAssertNotNil(obj[@"source"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
}

- (void)testSummaryDaily
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *day = [dateFormat dateFromString:@"2014-01-24"];
    
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client activity] summaryForDay:day onSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);
        
        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertNotNil(res[@"id"]);
        XCTAssertNotNil(res[@"date"]);
        XCTAssertNotNil(res[@"duration"]);
        XCTAssertNotNil(res[@"source"]);
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    } onFailure:^(NSError *error) {
        NSLog(@"Failure detected: %@", error);
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:10];
}


@end
