//
//  SendUITestsLaunchTests.m
//  SendUITests
//

#import <XCTest/XCTest.h>

@interface SendUITestsLaunchTests : XCTestCase

@end

@implementation SendUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    [self setContinueAfterFailure:NO];
}

- (void)testLaunch {
    XCUIApplication *app = [XCUIApplication new];
    [app launch];

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
