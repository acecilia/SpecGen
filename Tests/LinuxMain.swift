import XCTest

import swiftlintTests

var tests = [XCTestCaseEntry]()
tests += swiftlintTests.allTests()
XCTMain(tests)