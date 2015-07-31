//
//  HumanAPIClientTests2.m
//  HumanAPIDemo
//
//  Created by Yuri Subach on 03/03/15.
//  Copyright (c) 2015 Yuri Subach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HumanAPIClient.h"

@interface HumanAPIClientTest2 : XCTestCase

@end

@implementation HumanAPIClientTest2

- (void)setUp {
    [super setUp];

    // set access token
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    client.accessToken = @"demo";
}

- (void)tearDown {
    [super tearDown];
}

- (void)waitForExpectations {
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

// Human Entity

- (void)testHumanGet
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client human] getWithOnSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);

        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertNotNil(res[@"activitySummary"]);
        XCTAssertEqualObjects(@"52e20cb2fff56aac62000001", res[@"userId"]);

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];
}

// Profile Entity

- (void)testProfileGet
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client profile] getWithOnSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);

        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertEqualObjects(@"52e20cb2fff56aac62000001", res[@"userId"]);
        XCTAssertEqualObjects(@"demo@humanapi.co", res[@"email"]);

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];
}

// Genetic Trait Entity

- (void)testGeneticTraitList
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client geneticTrait] listWithOnSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);

        NSArray *res = (NSArray *)responseObject;
        XCTAssertTrue([res count] > 0);
        NSDictionary *obj = [res objectAtIndex:0];
        XCTAssertNotNil(obj[@"userId"]);
        XCTAssertNotNil(obj[@"trait"]);

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];
}

// Blood Glucose Entity

- (void)testBloodGlucoseLatest
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client bloodGlucose] latestWithOnSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);

        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertNotNil(res[@"id"]);
        XCTAssertNotNil(res[@"timestamp"]);
        XCTAssertNotNil(res[@"value"]);
        XCTAssertNotNil(res[@"source"]);

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];
}

- (void)testBloodGlucoseReadings
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
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

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];
}

- (void)testBloodGlucoseReading
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client bloodGlucose] reading:@"52e20cb3fff56aac6200044a" onSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);

        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertNotNil(res[@"id"]);
        XCTAssertNotNil(res[@"timestamp"]);
        XCTAssertNotNil(res[@"value"]);
        XCTAssertNotNil(res[@"source"]);

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];
}

- (void)testBloodGlucoseDaily
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
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

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];

}

// Activity Entity

- (void)testActivityList
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
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

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];

}

- (void)testActivityGet
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
    HumanAPIClient *client = [HumanAPIClient sharedHumanAPIClient];
    [[client activity] get:@"52e20cb5fff56aac62000b73" onSuccess:^(id responseObject) {
        NSLog(@"Success response: %@", responseObject);
        XCTAssertNotNil(responseObject);

        NSDictionary *res = (NSDictionary *)responseObject;
        XCTAssertNotNil(res[@"id"]);
        XCTAssertNotNil(res[@"startTime"]);
        XCTAssertNotNil(res[@"duration"]);
        XCTAssertNotNil(res[@"source"]);

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];
}

- (void)testActivityDaily
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
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

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];
}

- (void)testSummaryDaily
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"test ok"];
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

        [expectation fulfill];
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure detected: %@", error);
    }];
    [self waitForExpectations];
}


@end
