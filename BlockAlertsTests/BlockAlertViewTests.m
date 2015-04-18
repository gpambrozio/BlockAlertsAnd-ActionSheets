#import "BlockAlertView.h"

#import <XCTest/XCTest.h>

@interface BlockAlertViewTests : XCTestCase
@end

@implementation BlockAlertViewTests
{
    BlockAlertView *sut;
}

- (void)setUp
{
    [super setUp];
    sut = [BlockAlertView alertWithTitle:nil message:nil];
}

- (void)tearDown
{
    sut = nil;
    [super tearDown];
}

- (void)testDismissingWithClickOnButton_ShouldExecuteItsBlock
{
    __block BOOL block0Executed = NO;
    [sut addButtonWithTitle:@"BUTTON0" block:^{
        block0Executed = YES;
    }];
    __block BOOL block1Executed = NO;
    [sut addButtonWithTitle:@"BUTTON1" block:^{
        block1Executed = YES;
    }];
    [sut show];

    [sut dismissWithClickedButtonIndex:1 animated:NO];

    XCTAssertFalse(block0Executed);
    XCTAssertTrue(block1Executed);
}

- (void)testDismissingWithClickOnButton_withoutBlock_shouldNotDie
{
    [sut addButtonWithTitle:@"BUTTON0" block:nil];
    [sut show];

    [sut dismissWithClickedButtonIndex:0 animated:NO];

    // Don't die!
}

@end
