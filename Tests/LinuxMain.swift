#if os(Linux)
import XCTest

import LindenmeyerTests

var tests = [XCTestCaseEntry]()
tests += LindenmeyerTests.allTests()
XCTMain(tests)
#endif