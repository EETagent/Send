//
//  SendUITests.m
//  SendUITests
//

#import <XCTest/XCTest.h>

@interface SendUITests : XCTestCase

@end

@implementation SendUITests

- (void)setUp {
    [self setContinueAfterFailure:NO];
}

- (void)tearDown {}

- (void)testExample {
    XCUIApplication *app = [XCUIApplication new];
    [app launch];
}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)) {
        [self measureWithMetrics:@[[XCTApplicationLaunchMetric new]] block:^{
            [[XCUIApplication new] launch];
        }];
    }
}

@end
