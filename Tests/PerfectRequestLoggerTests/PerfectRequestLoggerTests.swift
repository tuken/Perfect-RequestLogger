import XCTest
@testable import PerfectRequestLogger
import PerfectLib

class PerfectRequestLoggerTests: XCTestCase {
  func testRandom() {
    for _ in 0..<16 {
      let r = RequestLogger()
      print(r.randomID)
      XCTAssertFalse(r.randomID.isEmpty)
      XCTAssertEqual(r.randomID.count, 8)
      XCTAssertNotEqual(r.randomID, "00000000")
    }
  }

  func testDate() {
    let now = getNow()
    let started = (try? formatDate(now, format: "%Y-%m-%d %H:%M:%S %z")) ?? "1970-01-01 00:00:00 +0000"
    print("timestamp:", started)
  }

  static var allTests : [(String, (PerfectRequestLoggerTests) -> () throws -> Void)] {
    return [
      ("testRandom", testRandom),
      ("testDate", testDate)
    ]
  }
}

